@tool
extends "res://addons/Vylox Extension/Core/VScript/VScript.gd"
class_name VCharacter2D

enum enum_character_option {None, Platformer, TopDown, Isometric}
var character_option: int = enum_character_option.None:
	set(value):
		character_option = value
		character_option = clamp(character_option, 0, enum_character_option.keys().size())

var tile_size: int = 0

func _ready():
	self.name = "VCharacter2D"

func _get_property_list() -> Array:
	var inspector = VInspector.new()
	
	inspector.create_category("VCharacter2D")
	inspector.create_enum("character_option", enum_character_option, true)
	
	if character_option == enum_character_option.Platformer:
		
		inspector.create_category("General Options")
		inspector.create_float("tile_size", true, 0, 128, 1)
		inspector.create_category("Movement")
		inspector.create_category("Motion")
		inspector.create_category("Force")
		inspector.create_category("Animation")
		inspector.create_category("Addition")
		
	
	return inspector.properties
