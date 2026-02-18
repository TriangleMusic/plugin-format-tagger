# Plugin Format Tagger — Max for Live

Scans every track in your Ableton Live Set and identifies whether each
third-party plugin is **AU**, **VST3**, or **VST2**. Optionally renames
the device in Live so the format is visible at a glance.

---

## Files

| File | Purpose |
|------|---------|
| `PluginFormatTagger.maxpat` | Max for Live device (open this) |
| `plugin_scanner.js` | JavaScript logic — must sit in the same folder |

---

## Installation

1. **Keep both files together** in the same folder (they already are).
2. In Live, open the browser → *Places* → navigate to this folder.
3. Drag **`PluginFormatTagger.maxpat`** onto any MIDI or Audio track.
4. The device opens in Presentation mode showing three controls.

> **Tip:** You can also save the device to your User Library so it appears
> under *Max for Live → Max MIDI Effect* or *Max Audio Effect*.

---

## Usage

| Control | Action |
|---------|--------|
| **Scan Project** | Scans all tracks (including Returns and Master), finds every AU / VST3 / VST2 plugin, and lists them in the results window. |
| **Add Tags** toggle | When ON, the next scan will also prefix each plugin's name in Live's device chain (e.g. `Serum` → `VST3 \| Serum`). Tagging is wrapped in an undo step — press **Cmd+Z** to revert all renames at once. |
| Results window | Scrollable list: `[FORMAT]  Track Name  –  Plugin Name` |
| Status bar | Shows scan progress and final count. |

---

## Format Detection Logic

```
device.info → type token
  AudioUnitDevice          →  AU
  PluginDevice + "vst3"
    in path/class_name     →  VST3
  PluginDevice (other)     →  VST2
  RackDevice               →  recurse into chains (not reported itself)
  anything else            →  skipped (native Ableton device)
```

Racks (Instrument Rack, Audio Rack, Drum Rack) are traversed recursively,
so plugins nested inside racks are detected correctly.

---

## Tagging & Undo

When **Add Tags** is ON:

- Existing prefix is stripped first to avoid double-tagging.
- The rename is wrapped in `begin_undo_step` / `end_undo_step`, so a
  single **Cmd+Z** reverts every rename from that scan.
- Running a scan with **Add Tags OFF** never renames anything.

---

## Known Limitations

- **VST2 vs VST3 disambiguation** relies on the `path` and `class_name`
  properties exposed by Live's LOM. If a VST3 plugin's path doesn't
  contain the string `"vst3"`, it will be reported as VST2. In practice
  this is rare — Ableton stores VST3 bundles under paths ending in `.vst3`.
- **Live 11 / 12 on macOS only.** The `AudioUnitDevice` type is a macOS
  concept; on Windows all AU entries would be absent.
- The device must be dropped on a track in Live — it won't function as a
  standalone Max patch outside of Live.

---

## Requirements

- Ableton Live 11 or 12
- Max for Live 8.x (included with Live Suite / add-on)
- macOS (AU detection is macOS-specific)
