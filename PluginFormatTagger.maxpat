{
	"patcher" : {
		"fileversion" : 1,
		"appversion" : {
			"major" : 8,
			"minor" : 6,
			"revision" : 0,
			"architecture" : "x64",
			"modernui" : 1
		},
		"rect" : [ 100.0, 100.0, 530.0, 740.0 ],
		"bglocked" : 0,
		"openinpresentation" : 1,
		"default_fontsize" : 12.0,
		"default_fontface" : 0,
		"default_fontname" : "Arial",
		"gridonopen" : 1,
		"gridsize" : [ 8.0, 8.0 ],
		"gridsnaponopen" : 1,
		"objectsnaponopen" : 1,
		"statusbarvisible" : 2,
		"toolbarvisible" : 1,
		"lefttoolbarpinned" : 0,
		"toptoolbarpinned" : 0,
		"righttoolbarpinned" : 0,
		"bottomtoolbarpinned" : 0,
		"toolbars_unpinned_last_save" : 0,
		"tallnewobj" : 0,
		"boxanimationtime" : 200,
		"enablehscroll" : 0,
		"enablevscroll" : 0,
		"devicewidth" : 0.0,
		"description" : "Scans all tracks for VST3 / AU / VST2 plugins and optionally tags them.",
		"digest" : "Plugin Format Tagger",
		"tags" : "utility plugins",
		"style" : "",
		"subpatcher_template" : "",
		"assistshowspatchername" : 0,
		"boxes" : [

			{
				"box" : {
					"id" : "obj-js",
					"maxclass" : "js",
					"numinlets" : 3,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 20.0, 480.0, 200.0, 22.0 ],
					"text" : "plugin_scanner.js"
				}
			},

			{
				"box" : {
					"id" : "obj-msg-scan",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 20.0, 430.0, 50.0, 22.0 ],
					"text" : "scan"
				}
			},

			{
				"box" : {
					"id" : "obj-msg-filter-all",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 20.0, 455.0, 70.0, 22.0 ],
					"text" : "filter ALL"
				}
			},

			{
				"box" : {
					"id" : "obj-msg-filter-au",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 100.0, 455.0, 60.0, 22.0 ],
					"text" : "filter AU"
				}
			},

			{
				"box" : {
					"id" : "obj-msg-filter-vst3",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 170.0, 455.0, 70.0, 22.0 ],
					"text" : "filter VST3"
				}
			},

			{
				"box" : {
					"id" : "obj-msg-filter-vst2",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 250.0, 455.0, 70.0, 22.0 ],
					"text" : "filter VST2"
				}
			},

			{
				"box" : {
					"id" : "obj-results",
					"maxclass" : "textedit",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 20.0, 520.0, 490.0, 40.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 104.0, 496.0, 390.0 ],
					"text" : "",
					"fontname" : "Courier New",
					"fontsize" : 11.0,
					"textcolor" : [ 0.9, 0.9, 0.9, 1.0 ],
					"bgcolor" : [ 0.08, 0.08, 0.08, 1.0 ],
					"editenabled" : 0,
					"wordwrap" : 0
				}
			},

			{
				"box" : {
					"id" : "obj-status-label",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 20.0, 570.0, 490.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 78.0, 490.0, 20.0 ],
					"text" : "Ready.",
					"fontsize" : 11.0,
					"textcolor" : [ 0.55, 0.55, 0.55, 1.0 ]
				}
			},

			{
				"box" : {
					"id" : "obj-scan-btn",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "int", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 20.0, 60.0, 150.0, 36.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 14.0, 150.0, 36.0 ],
					"text" : "Scan Project",
					"textjustification" : 2,
					"fontsize" : 14.0,
					"fontface" : 1,
					"bgcolor" : [ 0.118, 0.565, 0.973, 1.0 ],
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgoveroncolor" : [ 0.08, 0.40, 0.80, 1.0 ],
					"border" : 0,
					"rounded" : 6
				}
			},

			{
				"box" : {
					"id" : "obj-tag-toggle",
					"maxclass" : "toggle",
					"numinlets" : 1,
					"numoutlets" : 1,
					"outlettype" : [ "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 180.0, 68.0, 24.0, 24.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 176.0, 20.0, 24.0, 24.0 ]
				}
			},

			{
				"box" : {
					"id" : "obj-tag-label",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 208.0, 70.0, 120.0, 20.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 204.0, 22.0, 120.0, 20.0 ],
					"text" : "Add Tags",
					"fontsize" : 13.0,
					"textcolor" : [ 0.85, 0.85, 0.85, 1.0 ]
				}
			},

			{
				"box" : {
					"id" : "obj-filter-btn-all",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "int", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 20.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 58.0, 60.0, 22.0 ],
					"text" : "ALL",
					"textjustification" : 2,
					"fontsize" : 11.0,
					"fontface" : 1,
					"bgcolor" : [ 0.3, 0.3, 0.3, 1.0 ],
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgoveroncolor" : [ 0.5, 0.5, 0.5, 1.0 ],
					"border" : 0,
					"rounded" : 4
				}
			},

			{
				"box" : {
					"id" : "obj-filter-btn-au",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "int", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 86.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 80.0, 58.0, 60.0, 22.0 ],
					"text" : "AU",
					"textjustification" : 2,
					"fontsize" : 11.0,
					"fontface" : 1,
					"bgcolor" : [ 0.2, 0.5, 0.3, 1.0 ],
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgoveroncolor" : [ 0.15, 0.4, 0.25, 1.0 ],
					"border" : 0,
					"rounded" : 4
				}
			},

			{
				"box" : {
					"id" : "obj-filter-btn-vst3",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "int", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 152.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 146.0, 58.0, 60.0, 22.0 ],
					"text" : "VST3",
					"textjustification" : 2,
					"fontsize" : 11.0,
					"fontface" : 1,
					"bgcolor" : [ 0.5, 0.25, 0.5, 1.0 ],
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgoveroncolor" : [ 0.4, 0.18, 0.4, 1.0 ],
					"border" : 0,
					"rounded" : 4
				}
			},

			{
				"box" : {
					"id" : "obj-filter-btn-vst2",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "int", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 218.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 212.0, 58.0, 60.0, 22.0 ],
					"text" : "VST2",
					"textjustification" : 2,
					"fontsize" : 11.0,
					"fontface" : 1,
					"bgcolor" : [ 0.5, 0.35, 0.1, 1.0 ],
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"bgoveroncolor" : [ 0.4, 0.28, 0.08, 1.0 ],
					"border" : 0,
					"rounded" : 4
				}
			},

			{
				"box" : {
					"id" : "obj-title",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 20.0, 14.0, 300.0, 18.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, -2.0, 300.0, 16.0 ],
					"text" : "PLUGIN FORMAT TAGGER",
					"fontsize" : 9.0,
					"fontface" : 1,
					"textcolor" : [ 0.45, 0.45, 0.45, 1.0 ]
				}
			}

		],
		"lines" : [
			{
				"patchline" : {
					"source" : [ "obj-scan-btn", 0 ],
					"destination" : [ "obj-msg-scan", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-msg-scan", 0 ],
					"destination" : [ "obj-js", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-tag-toggle", 0 ],
					"destination" : [ "obj-js", 1 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-filter-btn-all", 0 ],
					"destination" : [ "obj-msg-filter-all", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-filter-btn-au", 0 ],
					"destination" : [ "obj-msg-filter-au", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-filter-btn-vst3", 0 ],
					"destination" : [ "obj-msg-filter-vst3", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-filter-btn-vst2", 0 ],
					"destination" : [ "obj-msg-filter-vst2", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-msg-filter-all", 0 ],
					"destination" : [ "obj-js", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-msg-filter-au", 0 ],
					"destination" : [ "obj-js", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-msg-filter-vst3", 0 ],
					"destination" : [ "obj-js", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-msg-filter-vst2", 0 ],
					"destination" : [ "obj-js", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-js", 0 ],
					"destination" : [ "obj-results", 0 ]
				}
			},
			{
				"patchline" : {
					"source" : [ "obj-js", 1 ],
					"destination" : [ "obj-status-label", 0 ]
				}
			}
		],
		"parameters" : {
			"obj-tag-toggle" : [ "AddTags", "Add Tags", 0 ]
		},
		"dependency_cache" : [
			{
				"name" : "plugin_scanner.js",
				"bootpath" : ".",
				"patcherrelativepath" : ".",
				"type" : "TEXT",
				"implicit" : 1
			}
		],
		"autosave" : 0
	}
}
