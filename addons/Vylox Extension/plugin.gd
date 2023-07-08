@tool
extends EditorPlugin

enum plugin_load {Loading, Loaded, Deloaded}

# vextension_tab is loaded by checking if the original folder's absolute path is resolved. If it didn't resolve,
# it'll return to null, which means that the file inside this Directory doesn't exist.
var vextension_tab = load(FileAccess.open("res://addons/Vylox Extension/Core/Vylox Extension Tab/Vylox Extension Tab.tscn", FileAccess.READ).get_path_absolute())
var instanced_vextension_tab: Control

var vscript_path = FileAccess.open("res://addons/Vylox Extension/Core/VScript/VScript.gd", FileAccess.READ).get_path()
var vevent_path = FileAccess.open("res://addons/Vylox Extension/Core/VEvent/VEvent.gd", FileAccess.READ).get_path()

var plugin_starts: int = plugin_load.Deloaded
var count_loads: int = 0
var max_loads: int = 3
var plugin_loaded_functions: Array = []

func _enter_tree():
	if vextension_tab != null: instanced_vextension_tab = vextension_tab.instantiate()
	plugin_starts = plugin_load.Loading

func _process(delta):
	# Plugin Autoloading System: This system will make sure, that Autoloaded scripts, which
	# extend to another Autoloaded script will load properly and in order to not print errors
	# and let the scripts work properly after Autoloading them.
	
	# For faster computing, if it's already on the Loaded state, we just return it, no
	# need for further calculation.
	if plugin_starts == plugin_load.Loaded:
		return
	
	# Resizing the Array to an appropriate size.
	if plugin_loaded_functions.size() != max_loads: plugin_loaded_functions.resize(max_loads)
	
	# If if it reached the max amount of loads, then set it to Loaded state.
	# If not, then for each progress frame, it loads all functions, in order,
	# matching with "count_loads". Some functions don't run, if the path doesn't exist
	# and those will not be stored on "plugin_loaded_functions" array.
	if plugin_starts == plugin_load.Loading:
		if count_loads == max_loads:
			plugin_starts = plugin_load.Loaded
			return
		if count_loads < max_loads and plugin_loaded_functions[count_loads] == null and vscript_path != null:
			match count_loads:
				# Replace the functions with any function you want.
				# Numbers indicate the amount of codes / functions running. Once it reaches
				# the maximum amount of loads (as in, reaching "max_loads" value),
				# plugin load will be set to Loaded state.
				0: 
					add_autoload_singleton("VScript", vscript_path)
					plugin_loaded_functions[count_loads] = "VScript"
					count_loads += 1
					return
				1: 
					if vevent_path != null:
						add_autoload_singleton("VEvent", vevent_path)
						plugin_loaded_functions[count_loads] = "VEvent"
					count_loads += 1
					return
				2: 
					if instanced_vextension_tab != null:
						add_control_to_bottom_panel(instanced_vextension_tab, "VInput")
						plugin_loaded_functions[count_loads] = "Vylox Extension Tab"
					count_loads += 1
					return

func _exit_tree():
	# Plugin Autoloading System: On exiting the tree, process() function will no longer run,
	# so this code will reset the plugin load state (Deloaded) and deload only the functions
	# with the corresponding number.
	if plugin_starts == plugin_load.Loaded:
		for i in max_loads:
			if plugin_loaded_functions[i] != null:
				plugin_loaded_functions[i] = null
				match i:
					0: remove_control_from_bottom_panel(instanced_vextension_tab)
					1: remove_autoload_singleton("VEvent")
					2: remove_autoload_singleton("VScript")
		plugin_starts = plugin_load.Deloaded
