/**
 * plugin_scanner.js — Max for Live
 * Plugin Format Tagger (macOS Edition)
 *
 * Inlets
 *   0 — "scan" (message/bang) : trigger full project scan
 *   1 — int 0/1               : Add Tags toggle
 *
 * Outlets
 *   0 — results textedit  :  "set <text>"  (Max prepend "set" pattern)
 *   1 — status comment    :  "set <text>"
 */

autowatch = 1;
outlets   = 2;

var addTagsEnabled = 0;

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

function scan() {
    setStatus("Scanning\u2026");
    clearResults();

    var results = [];

    try {
        var liveSet = new LiveAPI("live_set");

        var trackCount = liveSet.getcount("tracks");
        for (var t = 0; t < trackCount; t++) {
            var track     = new LiveAPI("live_set tracks " + t);
            var trackName = safeGet(track, "name");
            scanDevices(track, trackName, results, 0);
        }

        var returnCount = liveSet.getcount("return_tracks");
        for (var r = 0; r < returnCount; r++) {
            var rtrack     = new LiveAPI("live_set return_tracks " + r);
            var rtrackName = safeGet(rtrack, "name") + " [Ret]";
            scanDevices(rtrack, rtrackName, results, 0);
        }

        var master = new LiveAPI("live_set master_track");
        scanDevices(master, "Master", results, 0);

    } catch (err) {
        setStatus("Error: " + err.message);
        return;
    }

    if (results.length === 0) {
        setResults("(No third-party plugins found.)");
    } else {
        if (addTagsEnabled) { beginUndoStep(); }

        var lines = [];
        for (var i = 0; i < results.length; i++) {
            var res = results[i];
            if (addTagsEnabled) { applyTag(res.device, res.format, res.rawName); }
            lines.push(res.line);
        }

        if (addTagsEnabled) { endUndoStep(); }

        setResults(lines.join("\n"));
    }

    setStatus("Done \u2014 " + results.length + " plugin(s) found." +
              (addTagsEnabled ? " Tags applied." : ""));
}

// ─── scanning ────────────────────────────────────────────────────────────────

function scanDevices(track, trackName, results, depth) {
    var count = track.getcount("devices");
    for (var d = 0; d < count; d++) {
        var device = new LiveAPI(track.path + " devices " + d);
        scanDevice(device, trackName, results, depth);
    }
}

function scanDevice(device, trackName, results, depth) {
    var info    = device.info || "";
    var rawName = safeGet(device, "name");
    var type    = extractType(info);

    if (type === "RackDevice") {
        recurseRack(device, trackName, results, depth);
        return;
    }

    var format = detectFormat(type, info, device);
    if (format === "NATIVE") { return; }

    var prefix = depth > 0 ? spaces(depth * 2) + "\u2514 " : "";
    var line   = "[" + padRight(format, 4) + "]  " + prefix + trackName + "  \u2013  " + rawName;

    results.push({ line: line, device: device, format: format, rawName: rawName });
}

function recurseRack(device, trackName, results, depth) {
    var chainCount = device.getcount("chains");
    for (var c = 0; c < chainCount; c++) {
        var chain = new LiveAPI(device.path + " chains " + c);
        var dc    = chain.getcount("devices");
        for (var d = 0; d < dc; d++) {
            scanDevice(new LiveAPI(chain.path + " devices " + d),
                       trackName, results, depth + 1);
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
                scanDevice(new LiveAPI(pchain.path + " devices " + pd),
                           trackName, results, depth + 1);
            }
        }
    }
}

// ─── format detection ────────────────────────────────────────────────────────

function detectFormat(type, info, device) {
    if (type === "AudioUnitDevice") { return "AU"; }

    if (type === "PluginDevice") {
        var plugPath  = "";
        var className = "";
        try { plugPath  = (device.get("path")[0]       || "").toLowerCase(); } catch(e) {}
        try { className = (device.get("class_name")[0] || "").toLowerCase(); } catch(e) {}

        var combined = plugPath + " " + className + " " + info.toLowerCase();
        return (combined.indexOf("vst3") !== -1) ? "VST3" : "VST2";
    }

    return "NATIVE";
}

function extractType(info) {
    var m = info.match(/\btype\s+(\S+)/);
    return m ? m[1] : "";
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

/*
 * Max's [comment] and [textedit] both accept "set <text>" to update their
 * content.  We prepend "set" here in JS so the patch needs no extra objects.
 *
 * outlet(0, "set", text)  →  textedit receives message: set <text>
 * outlet(1, "set", text)  →  comment  receives message: set <text>
 *
 * Using the multi-argument outlet() form sends a typed Max message where the
 * first atom is the selector and the rest are arguments.
 */

function clearResults() {
    outlet(0, "set", "");
}

function setResults(text) {
    outlet(0, "set", text);
}

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
