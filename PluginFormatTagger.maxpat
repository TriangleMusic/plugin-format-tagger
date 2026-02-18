{
	"patcher" : 	{
		"fileversion" : 1,
		"appversion" : 		{
			"major" : 9,
			"minor" : 0,
			"revision" : 10,
			"architecture" : "x64",
			"modernui" : 1
		}
,
		"classnamespace" : "box",
		"rect" : [ 100.0, 100.0, 530.0, 740.0 ],
		"openinpresentation" : 1,
		"gridsize" : [ 8.0, 8.0 ],
		"enablehscroll" : 0,
		"enablevscroll" : 0,
		"description" : "Scans all tracks for VST3 / AU / VST2 plugins and optionally tags them.",
		"digest" : "Plugin Format Tagger",
		"tags" : "utility plugins",
		"boxes" : [ 			{
				"box" : 				{
					"id" : "obj-js",
					"maxclass" : "js",
					"numinlets" : 2,
					"numoutlets" : 2,
					"outlettype" : [ "", "" ],
					"patching_rect" : [ 20.0, 490.0, 200.0, 22.0 ],
					"text" : "plugin_scanner.js"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-msg-scan",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 20.0, 430.0, 50.0, 22.0 ],
					"text" : "scan"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-msg-filter-all",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 20.0, 455.0, 70.0, 22.0 ],
					"text" : "filter ALL"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-msg-filter-au",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 100.0, 455.0, 60.0, 22.0 ],
					"text" : "filter AU"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-msg-filter-vst3",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 170.0, 455.0, 70.0, 22.0 ],
					"text" : "filter VST3"
				}

			}
, 			{
				"box" : 				{
					"id" : "obj-msg-filter-vst2",
					"maxclass" : "message",
					"numinlets" : 2,
					"numoutlets" : 1,
					"outlettype" : [ "" ],
					"patching_rect" : [ 250.0, 455.0, 70.0, 22.0 ],
					"text" : "filter VST2"
				}

			}
, 			{
				"box" : 				{
					"bgcolor" : [ 0.08, 0.08, 0.08, 1.0 ],
					"fontname" : "Courier New",
					"fontsize" : 11.0,
					"id" : "obj-results",
					"maxclass" : "textedit",
					"numinlets" : 1,
					"numoutlets" : 4,
					"outlettype" : [ "", "int", "", "" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 20.0, 520.0, 490.0, 40.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 104.0, 496.0, 390.0 ],
					"textcolor" : [ 0.9, 0.9, 0.9, 1.0 ],
					"wordwrap" : 0
				}

			}
, 			{
				"box" : 				{
					"fontsize" : 11.0,
					"id" : "obj-status-label",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 20.0, 570.0, 490.0, 19.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 78.0, 490.0, 19.0 ],
					"text" : "Ready.",
					"textcolor" : [ 0.55, 0.55, 0.55, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"align" : 2,
					"bgcolor" : [ 0.118, 0.565, 0.973, 1.0 ],
					"fontface" : 1,
					"fontsize" : 14.0,
					"id" : "obj-scan-btn",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 20.0, 60.0, 150.0, 36.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 14.0, 150.0, 36.0 ],
					"rounded" : 6.0,
					"text" : "Scan Project",
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
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

			}
, 			{
				"box" : 				{
					"fontsize" : 13.0,
					"id" : "obj-tag-label",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 208.0, 70.0, 120.0, 21.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 204.0, 22.0, 120.0, 21.0 ],
					"text" : "Add Tags",
					"textcolor" : [ 0.85, 0.85, 0.85, 1.0 ]
				}

			}
, 			{
				"box" : 				{
					"align" : 2,
					"bgcolor" : [ 0.3, 0.3, 0.3, 1.0 ],
					"fontface" : 1,
					"fontsize" : 11.0,
					"id" : "obj-filter-btn-all",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 20.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, 58.0, 60.0, 22.0 ],
					"rounded" : 4.0,
					"text" : "ALL",
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
					"align" : 2,
					"bgcolor" : [ 0.2, 0.5, 0.3, 1.0 ],
					"fontface" : 1,
					"fontsize" : 11.0,
					"id" : "obj-filter-btn-au",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 86.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 80.0, 58.0, 60.0, 22.0 ],
					"rounded" : 4.0,
					"text" : "AU",
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
					"align" : 2,
					"bgcolor" : [ 0.5, 0.25, 0.5, 1.0 ],
					"fontface" : 1,
					"fontsize" : 11.0,
					"id" : "obj-filter-btn-vst3",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 152.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 146.0, 58.0, 60.0, 22.0 ],
					"rounded" : 4.0,
					"text" : "VST3",
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
					"align" : 2,
					"bgcolor" : [ 0.5, 0.35, 0.1, 1.0 ],
					"fontface" : 1,
					"fontsize" : 11.0,
					"id" : "obj-filter-btn-vst2",
					"maxclass" : "textbutton",
					"numinlets" : 1,
					"numoutlets" : 3,
					"outlettype" : [ "", "", "int" ],
					"parameter_enable" : 0,
					"patching_rect" : [ 218.0, 110.0, 60.0, 26.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 212.0, 58.0, 60.0, 22.0 ],
					"rounded" : 4.0,
					"text" : "VST2",
					"textcolor" : [ 1.0, 1.0, 1.0, 1.0 ],
					"textjustification" : 2
				}

			}
, 			{
				"box" : 				{
					"fontface" : 1,
					"fontsize" : 9.0,
					"id" : "obj-title",
					"maxclass" : "comment",
					"numinlets" : 1,
					"numoutlets" : 0,
					"patching_rect" : [ 20.0, 14.0, 300.0, 17.0 ],
					"presentation" : 1,
					"presentation_rect" : [ 14.0, -2.0, 300.0, 17.0 ],
					"text" : "PLUGIN FORMAT TAGGER",
					"textcolor" : [ 0.45, 0.45, 0.45, 1.0 ]
				}

			}
 ],
		"lines" : [ 			{
			"patchline" : 				{
					"destination" : [ "obj-msg-scan", 0 ],
					"source" : [ "obj-scan-btn", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-js", 0 ],
					"source" : [ "obj-msg-scan", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-msg-filter-all", 0 ],
					"source" : [ "obj-filter-btn-all", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-js", 0 ],
					"source" : [ "obj-msg-filter-all", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-msg-filter-au", 0 ],
					"source" : [ "obj-filter-btn-au", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-js", 0 ],
					"source" : [ "obj-msg-filter-au", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-msg-filter-vst3", 0 ],
					"source" : [ "obj-filter-btn-vst3", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-js", 0 ],
					"source" : [ "obj-msg-filter-vst3", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-msg-filter-vst2", 0 ],
					"source" : [ "obj-filter-btn-vst2", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-js", 0 ],
					"source" : [ "obj-msg-filter-vst2", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-js", 1 ],
					"source" : [ "obj-tag-toggle", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-results", 0 ],
					"source" : [ "obj-js", 0 ]
				}

			}
, 			{
			"patchline" : 				{
					"destination" : [ "obj-status-label", 0 ],
					"source" : [ "obj-js", 1 ]
				}

			}
 ],
		"dependency_cache" : [ { "name" : "plugin_scanner.js", "bootpath" : ".", "patcherrelativepath" : ".", "type" : "TEXT", "implicit" : 1 } ],
		"autosave" : 0,
		"oscreceiveudpport" : 0
	}

}
