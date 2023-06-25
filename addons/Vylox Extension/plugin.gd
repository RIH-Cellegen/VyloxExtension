@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("VScript", "Core/VScript/VScript.gd")
	add_autoload_singleton("VInput", "Core/VInput/Vinput.gd")
	add_autoload_singleton("VEvent", "Core/VEvent/VEvent.gd")


func _exit_tree():
	remove_autoload_singleton("VScript")
	remove_autoload_singleton("VInput")
	remove_autoload_singleton("VEvent")
