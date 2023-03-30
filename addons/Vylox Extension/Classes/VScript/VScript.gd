@tool
@icon("res://addons/Vylox Extension/Classes/VScript/VScript.svg")
extends Node2D
class_name VScript
## Advanced Script class, that provides functions, which may speed up development.

var cycle_count: int

## Advanced function, which replaces clamp() for Vector2 Variables.
## It has the same use as clamp(), only that it needs a Vector2 as a value.
static func clamp_vector2(value: Vector2, min: Variant, max: Variant):
    value.x = clamp(value.x, min, max)
    value.y = clamp(value.y, min, max)
    return value
