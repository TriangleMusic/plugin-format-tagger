/**
 * plugin_scanner.js — Max for Live
 * Plugin Format Tagger
 *
 * Inlets
 *   0 — "scan" / bang / "filter <str>" : trigger scan or filter
 *   1 — int 0/1                         : Add Tags toggle
 *
 * Outlets
 *   0 — results textedit : "set <text>"
 *   1 — status comment   : "set <text>"
 */

autowatch = 1;
outlets   = 2;

// Runs immediately on load — proves JS is alive
post("plugin_scanner.js loaded OK\n");
outlet(1, "set", "JS loaded. Press Scan Project.");

var addTagsEnabled = 0;
var currentFilter  = "ALL";
var allResults     = [];

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

function filter(f) {
    currentFilter = String(f).toUpperCase();
    setStatus("Filter: " + currentFilter);
    renderResults();
}

function scan() {
    setStatus("Scanning\u2026");
    outlet(0, "set", "");
    allResults = [];

    var debugLines = [];

    try {
        var liveSet = new LiveAPI("live_set");
        var trackCount = liveSet.getcount("tracks");
        debugLines.push("Tracks found: " + trackCount);

        for (var t = 0; t < trackCount; t++) {
            var track     = new LiveAPI("live_set tracks " + t);
            var trackName = safeGet(track, "name");
            var devCount  = track.getcount("devices");
            debugLines.push("  Track " + t + " [" + trackName + "] devices: " + devCount);

            for (var d = 0; d < devCount; d++) {
                var device  = new LiveAPI("live_set tracks " + t + " devices " + d);
                var devName = safeGet(device, "name");
                var dtype   = getDeviceType(device);
                debugLines.push("    Device " + d + ": name=" + devName + " type=" + dtype);

                processDevice(device, trackName, dtype, devName, 0);
            }
        }

        // Return tracks
        var returnCount = liveSet.getcount("return_tracks");
        for (var r = 0; r < returnCount; r++) {
            var rtrack    = new LiveAPI("live_set return_tracks " + r);
            var rName     = safeGet(rtrack, "name") + " [Ret]";
            var rDevCount = rtrack.getcount("devices");
            for (var rd = 0; rd < rDevCount; rd++) {
                var rdev   = new LiveAPI("live_set return_tracks " + r + " devices " + rd);
                var rdName = safeGet(rdev, "name");
                var rdtype = getDeviceType(rdev);
                processDevice(rdev, rName, rdtype, rdName, 0);
            }
        }

        // Master
        var master    = new LiveAPI("live_set master_track");
        var mDevCount = master.getcount("devices");
        for (var md = 0; md < mDevCount; md++) {
            var mdev   = new LiveAPI("live_set master_track devices " + md);
            var mdName = safeGet(mdev, "name");
            var mdtype = getDeviceType(mdev);
            processDevice(mdev, "Master", mdtype, mdName, 0);
        }

    } catch (err) {
        setStatus("Error: " + err.message);
        outlet(0, "set", "ERROR: " + err.message + "\n\n" + debugLines.join("\n"));
        return;
    }

    if (allResults.length === 0) {
        outlet(0, "set", "(No third-party plugins found.)\n\nDebug:\n" + debugLines.join("\n"));
        setStatus("Done \u2014 0 plugins found.");
    } else {
        if (addTagsEnabled) {
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
}

// ─── device type detection ───────────────────────────────────────────────────

function getDeviceType(device) {
    // Method 1: try device.type (works in newer M4L)
    try {
        var t = device.type;
        if (t && String(t) !== "undefined" && String(t) !== "") {
            return String(t);
        }
    } catch(e) {}

    // Method 2: try get("type")
    try {
        var arr = device.get("type");
        if (arr && arr.length > 0) {
            return String(arr[0]);
        }
    } catch(e) {}

    // Method 3: inspect device.info string
    try {
        var info = device.info || "";
        var m = String(info).match(/\btype\s+(\S+)/);
        if (m) { return m[1]; }
    } catch(e) {}

    // Method 4: check class_name / path for plugin hints
    try {
        var cn = String(device.get("class_name")[0] || "").toLowerCase();
        if (cn.indexOf("audiounitmxdevice") !== -1) { return "AudioUnitDevice"; }
        if (cn.indexOf("plugindevice") !== -1)      { return "PluginDevice"; }
        if (cn.indexOf("midieffect") !== -1)         { return "MidiEffectDevice"; }
        if (cn.indexOf("instrument") !== -1)         { return "InstrumentDevice"; }
        if (cn.indexOf("audioeffect") !== -1)        { return "AudioEffectDevice"; }
    } catch(e) {}

    return "Unknown";
}

// ─── processing ──────────────────────────────────────────────────────────────

function processDevice(device, trackName, dtype, rawName, depth) {
    if (dtype === "RackDevice") {
        recurseRack(device, trackName, depth);
        return;
    }

    var format = detectFormat(dtype, device);
    if (format === "NATIVE") { return; }

    var prefix = depth > 0 ? spaces(depth * 2) + "\u2514 " : "";
    var line   = "[" + padRight(format, 4) + "]  " + prefix + trackName + "  \u2013  " + rawName;

    allResults.push({ line: line, device: device, format: format, rawName: rawName });
}

function recurseRack(device, trackName, depth) {
    try {
        var chainCount = device.getcount("chains");
        for (var c = 0; c < chainCount; c++) {
            var chain = new LiveAPI(device.path + " chains " + c);
            var dc    = chain.getcount("devices");
            for (var d = 0; d < dc; d++) {
                var sub   = new LiveAPI(chain.path + " devices " + d);
                var sname = safeGet(sub, "name");
                var stype = getDeviceType(sub);
                processDevice(sub, trackName, stype, sname, depth + 1);
            }
        }
    } catch(e) {}

    try {
        var padCount = device.getcount("drum_pads");
        for (var p = 0; p < padCount; p++) {
            var pad = new LiveAPI(device.path + " drum_pads " + p);
            var pc  = pad.getcount("chains");
            for (var pci = 0; pci < pc; pci++) {
                var pchain = new LiveAPI(pad.path + " chains " + pci);
                var pdc    = pchain.getcount("devices");
                for (var pd = 0; pd < pdc; pd++) {
                    var psub   = new LiveAPI(pchain.path + " devices " + pd);
                    var psname = safeGet(psub, "name");
                    var pstype = getDeviceType(psub);
                    processDevice(psub, trackName, pstype, psname, depth + 1);
                }
            }
        }
    } catch(e) {}
}

// ─── format detection ────────────────────────────────────────────────────────

function detectFormat(dtype, device) {
    if (dtype === "AudioUnitDevice") { return "AU"; }

    if (dtype === "PluginDevice") {
        var plugPath  = "";
        var className = "";
        try { plugPath  = String(device.get("path")[0]       || "").toLowerCase(); } catch(e) {}
        try { className = String(device.get("class_name")[0] || "").toLowerCase(); } catch(e) {}
        var combined = plugPath + " " + className;
        return (combined.indexOf("vst3") !== -1) ? "VST3" : "VST2";
    }

    return "NATIVE";
}

// ─── render ──────────────────────────────────────────────────────────────────

function renderResults() {
    if (allResults.length === 0) {
        outlet(0, "set", "(No plugins found.)");
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

// ─── tagging ─────────────────────────────────────────────────────────────────

var PREFIXES = ["AU | ", "VST3 | ", "VST2 | "];

function applyTag(device, format, rawName) {
    var stripped = rawName;
    for (var i = 0; i < PREFIXES.length; i++) {
        if (stripped.indexOf(PREFIXES[i]) === 0) {
            stripped = stripped.slice(PREFIXES[i].length);
            break;
        }
    }
    var prefix  = (format === "AU") ? "AU | " : (format === "VST3") ? "VST3 | " : "VST2 | ";
    var newName = prefix + stripped;
    if (newName === rawName) { return; }
    try { device.set("name", newName); } catch(e) {}
}

function beginUndoStep() {
    try { new LiveAPI("live_app").call("begin_undo_step"); } catch(e) {}
}
function endUndoStep() {
    try { new LiveAPI("live_app").call("end_undo_step"); } catch(e) {}
}

// ─── helpers ─────────────────────────────────────────────────────────────────

function setStatus(text) { outlet(1, "set", text); }

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
