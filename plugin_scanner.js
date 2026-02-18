/**
 * plugin_scanner.js — Max for Live
 * Plugin Format Tagger
 *
 * Inlets
 *   0 — "scan" / bang        : trigger full project scan
 *   1 — int 0/1              : Add Tags toggle
 *   2 — "filter <str>"       : set filter ("ALL", "AU", "VST3", "VST2")
 *
 * Outlets
 *   0 — results textedit     : "set <text>"
 *   1 — status comment       : "set <text>"
 */

autowatch = 1;
outlets   = 2;

var addTagsEnabled = 0;
var currentFilter  = "ALL";   // "ALL" | "AU" | "VST3" | "VST2"
var allResults     = [];      // cache last scan so filter is instant

// ─── inlet routing ──────────────────────────────────────────────────────────

function msg_int(v) {
    if (inlet === 1) {
        addTagsEnabled = v ? 1 : 0;
        setStatus("Add Tags: " + (addTagsEnabled ? "ON" : "OFF"));
    }
}

function bang() {
    if (inlet === 0) { scan(); }
}

// called from filter buttons: filter AU / filter VST3 / filter ALL etc.
function filter(f) {
    currentFilter = String(f).toUpperCase();
    renderResults();
}

function scan() {
    setStatus("Scanning\u2026");
    outlet(0, "set", "");
    allResults = [];

    try {
        var liveSet = new LiveAPI("live_set");

        var trackCount = liveSet.getcount("tracks");
        for (var t = 0; t < trackCount; t++) {
            var track     = new LiveAPI("live_set tracks " + t);
            var trackName = safeGet(track, "name");
            scanDevices(track, trackName, 0);
        }

        var returnCount = liveSet.getcount("return_tracks");
        for (var r = 0; r < returnCount; r++) {
            var rtrack     = new LiveAPI("live_set return_tracks " + r);
            var rtrackName = safeGet(rtrack, "name") + " [Ret]";
            scanDevices(rtrack, rtrackName, 0);
        }

        var master = new LiveAPI("live_set master_track");
        scanDevices(master, "Master", 0);

    } catch (err) {
        setStatus("Error: " + err.message);
        return;
    }

    if (addTagsEnabled && allResults.length > 0) {
        beginUndoStep();
        for (var i = 0; i < allResults.length; i++) {
            applyTag(allResults[i].device, allResults[i].format, allResults[i].rawName);
        }
        endUndoStep();
    }

    setStatus("Done \u2014 " + allResults.length + " plugin(s) found." +
              (addTagsEnabled ? " Tags applied." : ""));

    renderResults();
}

function renderResults() {
    if (allResults.length === 0) {
        outlet(0, "set", "(No third-party plugins found.)");
        return;
    }

    var lines = [];
    for (var i = 0; i < allResults.length; i++) {
        var res = allResults[i];
        if (currentFilter === "ALL" || res.format === currentFilter) {
            lines.push(res.line);
        }
    }

    if (lines.length === 0) {
        outlet(0, "set", "(No " + currentFilter + " plugins found.)");
    } else {
        outlet(0, "set", lines.join("\n"));
    }
}

// ─── scanning ────────────────────────────────────────────────────────────────

function scanDevices(track, trackName, depth) {
    var count = track.getcount("devices");
    for (var d = 0; d < count; d++) {
        var device = new LiveAPI(track.path + " devices " + d);
        scanDevice(device, trackName, depth);
    }
}

function scanDevice(device, trackName, depth) {
    // device.type returns a string like "AudioUnitDevice", "PluginDevice", "RackDevice", etc.
    var dtype   = String(device.type);
    var rawName = safeGet(device, "name");

    if (dtype === "RackDevice") {
        recurseRack(device, trackName, depth);
        return;
    }

    var format = detectFormat(dtype, device);
    if (format === "NATIVE") { return; }

    var prefix = depth > 0 ? spaces(depth * 2) + "\u2514 " : "";
    var line   = "[" + padRight(format, 4) + "]  " + prefix + trackName + "  \u2013  " + rawName;

    allResults.push({ line: line, device: device, format: format, rawName: rawName, track: trackName });
}

function recurseRack(device, trackName, depth) {
    var chainCount = device.getcount("chains");
    for (var c = 0; c < chainCount; c++) {
        var chain = new LiveAPI(device.path + " chains " + c);
        var dc    = chain.getcount("devices");
        for (var d = 0; d < dc; d++) {
            scanDevice(new LiveAPI(chain.path + " devices " + d), trackName, depth + 1);
        }
    }

    var padCount = device.getcount("drum_pads");
    for (var p = 0; p < padCount; p++) {
        var pad = new LiveAPI(device.path + " drum_pads " + p);
        var pc  = pad.getcount("chains");
        for (var pci = 0; pci < pc; pci++) {
            var pchain = new LiveAPI(pad.path + " chains " + pci);
            var pdc    = pchain.getcount("devices");
            for (var pd = 0; pd < pdc; pd++) {
                scanDevice(new LiveAPI(pchain.path + " devices " + pd), trackName, depth + 1);
            }
        }
    }
}

// ─── format detection ────────────────────────────────────────────────────────

function detectFormat(dtype, device) {
    if (dtype === "AudioUnitDevice") { return "AU"; }

    if (dtype === "PluginDevice") {
        // Try to read device path or class_name to distinguish VST3 vs VST2
        var plugPath  = "";
        var className = "";
        try { plugPath  = String(device.get("path")[0]       || "").toLowerCase(); } catch(e) {}
        try { className = String(device.get("class_name")[0] || "").toLowerCase(); } catch(e) {}
        // VST3 files live in .vst3 bundles
        var combined = plugPath + " " + className;
        return (combined.indexOf("vst3") !== -1) ? "VST3" : "VST2";
    }

    return "NATIVE";
}

// ─── tagging ─────────────────────────────────────────────────────────────────

var PREFIXES = ["AU | ", "VST3 | ", "VST2 | "];

function prefixFor(format) {
    if (format === "AU")   { return "AU | ";   }
    if (format === "VST3") { return "VST3 | "; }
    return "VST2 | ";
}

function applyTag(device, format, rawName) {
    var stripped = rawName;
    for (var i = 0; i < PREFIXES.length; i++) {
        if (stripped.indexOf(PREFIXES[i]) === 0) {
            stripped = stripped.slice(PREFIXES[i].length);
            break;
        }
    }
    var newName = prefixFor(format) + stripped;
    if (newName === rawName) { return; }
    try { device.set("name", newName); }
    catch(e) { setStatus("Warn: could not rename \"" + rawName + "\""); }
}

// ─── undo ────────────────────────────────────────────────────────────────────

function beginUndoStep() {
    try { new LiveAPI("live_app").call("begin_undo_step"); } catch(e) {}
}
function endUndoStep() {
    try { new LiveAPI("live_app").call("end_undo_step"); } catch(e) {}
}

// ─── output helpers ──────────────────────────────────────────────────────────

function setStatus(text) {
    outlet(1, "set", text);
}

// ─── utilities ───────────────────────────────────────────────────────────────

function safeGet(obj, prop) {
    try {
        var v = obj.get(prop);
        return (v && v.length) ? String(v[0]) : "";
    } catch(e) { return ""; }
}

function spaces(n) {
    var s = "";
    for (var i = 0; i < n; i++) { s += " "; }
    return s;
}

function padRight(str, len) {
    while (str.length < len) { str += " "; }
    return str;
}
