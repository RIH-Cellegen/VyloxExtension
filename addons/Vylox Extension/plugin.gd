@tool
extends EditorPlugin

var path_VScript = FileAccess.open("res://addons/vylox_extension/Autoloaded Scripts/VScript/VScript.gd", FileAccess.READ).get_path()

func _enter_tree():
	if path_VScript != null: add_autoload_singleton("VScript", path_VScript)

func _exit_tree():
	remove_autoload_singleton("VScript")
