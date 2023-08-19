extends Node

static func clamp_vector2(value: Vector2, min_val: Variant, max_val: Variant) -> Vector2:
	value.x = clamp(value.x, min_val, max_val)
	value.y = clamp(value.y, min_val, max_val)
	return value

static func clamp_vector3(value: Vector3, min_val: Variant, max_val: Variant) -> Vector3:
	value.x = clamp(value.x, min_val, max_val)
	value.y = clamp(value.y, min_val, max_val)
	value.z = clamp(value.z, min_val, max_val)
	return value

static func clamp_vector4(value: Vector4, min_val: Variant, max_val: Variant) -> Vector4:
	value.w = clamp(value.x, min_val, max_val)
	value.x = clamp(value.y, min_val, max_val)
	value.y = clamp(value.z, min_val, max_val)
	value.z = clamp(value.w, min_val, max_val)
	return value

static func quaternion2vector4(value: Quaternion) -> Vector4:
	return Vector4(value.x, value.y, value.z, value.w)

static func vector42quaternion(value: Vector4) -> Quaternion:
	return Quaternion(value.x, value.y, value.z, value.w)

# Used in VInspector. It turns all of the enum's keys into a String, containing keys as Strings.
# It can exclude values or not capitalize words, when using the function.
static func enum2str(enum_dict: Dictionary, include_values := false, capitalize_words := true) -> String:
	var enum_string = ""
	if include_values:
		for k in enum_dict.keys():
			if !capitalize_words:
				enum_string += k + ":" + str(enum_dict[k]) + ","
				continue
			if capitalize_words:
				enum_string += k.capitalize() + ":" + str(enum_dict[k]) + ","
				continue
	else:
		for k in enum_dict.keys():
			if !capitalize_words:
				enum_string += k + ","
				continue
			if capitalize_words:
				enum_string += k.capitalize() + ","
				continue
	if enum_string.length() > 0:
		enum_string = enum_string.substr(0, enum_string.length() - 1)
	return enum_string

static func distance(a: Variant, b: Variant) -> Variant:
	if (a is int and b is int) or (a is float and b is float):
		return abs(a - b)
	if a is Vector2 and b is Vector2:
		return Vector2(abs(a.x - b.x), abs(a.y - b.y))
	
	return 0

static func variable_equals_to(variable, to): ## Checks if the parameters are either the same type or same value and returns the result.
	if typeof(variable) != typeof(to): return false # Check if the "variable" is the same type as "to"
	return true if variable == to else false # And if they are, then see if it's the same value

static func is_outside_editor() -> bool:
	return false if Engine.is_editor_hint() else true

static func is_inside_editor() -> bool:
	return true if Engine.is_editor_hint() else false

## [b](Outside Editor Function) - Spawns an Object or a PackedScene as a Node where it's specified.[/b][br][br]✅ Set the [b]"current node"[/b] to "self", for cases of avoiding infinite loops.[br]⚠️ Setting both the [b]"node"[/b] and [b]"or_packed_scene"[/b] parameter will result in using [b]"node"[/b] only.
static func create_node(current_node: Node, from_node: Node, node: Object = null, or_packed_scene: PackedScene = null):
	# to avoid further errors in finding the Node
	if from_node == null:
		push_error("⚠️ Warning in function create_node() called inside VScript2D: first parameter is null! \nThe function will not work, unless the first parameter is filled!")
		return
	
	# avoiding infinite recursion (infinite loops)
	if current_node == from_node:
		push_error("🚧 Error in function create_node() called inside VScript2D: The current Node (first parameter) is identical with the \ntargeted Node (second parameter), causing an infinite loop of spawning itself! \nFor the sake of no memory leaks, the function will not work, unless either the first or second parameter has been changed!")
		return
	
	# using "node" parameter only
	if node != null and or_packed_scene == null:
		from_node.add_child(node)
		return
	
	# using "or_packed_scene" parameter only
	if or_packed_scene != null and node == null:
		from_node.add_child(or_packed_scene.instantiate())
		return
	
	if or_packed_scene != null and node != null:
		push_warning("⚠️ Warning in function create_node() called inside VScript2D: both third and fourth parameters are filled, \nthus priority goes to the " + '"node"' + " parameter only!")
		push_warning("Using parameter: " + str(node) + " | Unused parameter: " + str(or_packed_scene))
		from_node.add_child(node)
		return
	
	push_warning("⚠️ Warning in function create_node() called inside VScript2D: both third and fourth parameters are null! \nThe function will not work, unless either the third or fourth parameters are filled!")

static func remove_node(from_node: Node, node: Object = null, or_packed_scene: PackedScene = null):
	var instanced_packed_scene = or_packed_scene.instantiate()
	
	# to avoid further errors in finding the Node
	if from_node == null:
		push_error("⚠️ Warning in function remove_node() called inside VScript2D: first parameter is null! \nThe function will not work, unless the first parameter is filled!")
		return
	
	# using "node" parameter only
	if node != null and or_packed_scene == null:
		from_node.remove_child(node)
		return
	
	# using "or_packed_scene" parameter only
	if or_packed_scene != null and node == null:
		from_node.find_child(or_packed_scene.resource_name).queue_free()
		return
	
	if or_packed_scene != null and node != null:
		push_warning("⚠️ Warning in function remove_node() called inside VScript2D: both second and third parameters are filled, \nthus priority goes to the first parameter only!")
		push_warning("Using parameter: " + str(node) + " | Unused parameter: " + str(or_packed_scene))
		from_node.remove_child(node)
	
	push_warning("⚠️ Warning in function remove_node() called inside VScript2D: both third and fourth parameters are null! \nThe function will not work, unless either the third or fourth parameters are filled!")

static func remove_all_nodes(from_node: Node):
	# to avoid further errors in finding the Node
	if from_node == null:
		push_error("⚠️ Warning in function remove_all_nodes() called inside VScript2D: first parameter is null! \nThe function will not work, unless the first parameter is filled!")
		return
	
	# Get the amount of childs in that Node. This value will not change, so it's safely usable for the for loop.
	var child_count = from_node.get_child_count()
	
	if child_count != 0:
		for amount in child_count:
				from_node.get_child(0).queue_free()
		return
	
	push_warning("⚠️ Warning in function remove_all_nodes() called inside VScript2D: the first parameter has no childs attached to it, thus the function will end.")
