@tool
extends Node
class_name VScript

func clamp_vector2(value: Vector2, min_val: Variant, max_val: Variant):
	value.x = clamp(value.x, min_val, max_val)
	value.y = clamp(value.y, min_val, max_val)
	return value

func clamp_vector3(value: Vector3, min_val: Variant, max_val: Variant):
	value.x = clamp(value.x, min_val, max_val)
	value.y = clamp(value.y, min_val, max_val)
	value.z = clamp(value.z, min_val, max_val)
	return value

func clamp_vector4(value: Vector4, min_val: Variant, max_val: Variant):
	value.w = clamp(value.x, min_val, max_val)
	value.x = clamp(value.y, min_val, max_val)
	value.y = clamp(value.z, min_val, max_val)
	value.z = clamp(value.w, min_val, max_val)
	return value

func quaternion_2_vector4(value: Quaternion) -> Vector4:
	return Vector4(value.x, value.y, value.z, value.w)

func vector4_2_quaternion(value: Vector4) -> Quaternion:
	return Quaternion(value.x, value.y, value.z, value.w)

# Used in VInspector. It turns all of the enum's keys into a String, containing keys as Strings.
# It can exclude values or not capitalize words, when using the function.
func enum2str(enum_dict: Dictionary, include_values := false, capitalize_words := true) -> String:
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
