extends VScript
class_name VInspector

@export var properties: Array

enum Variable_type {
	Nil = 0,
	Bool,
	Int,
	Float,
	String,
	Vector2,
	Vector2i,
	Rect2,
	Rect2i,
	Vector3,
	Vector3i,
	Transform2D,
	Vector4,
	Vector4i,
	Plane,
	Quaternion,
	AABB,
	Basis,
	Transform3D,
	Projection,
	Color,
	StringName,
	NodePath,
	RID,
	Object,
	Callable,
	Signal,
	Dictionary,
	Array,
	PackedByteArray,
	PackedInt32Array,
	PackedInt64Array,
	PackedFloat32Array,
	PackedFloat64Array,
	PackedStringArray,
	PackedVector2Array,
	PackedVector3Array,
	PackedColorArray,
	Enum = 38
}

enum Property_hint {
	NONE,
	RANGE,
	ENUM,
	ENUM_SUGGESTION,
	EXP_EASING,
	LINK,
	FLAGS,
	LAYERS_2D_RENDER,
	LAYERS_2D_PHYSICS,
	LAYERS_2D_NAVIGATION,
	LAYERS_3D_RENDER,
	LAYERS_3D_PHYSICS,
	LAYERS_3D_NAVIGATION,
	FILE,
	DIR,
	GLOBAL_FILE,
	GLOBAL_DIR,
	RESOURCE_TYPE,
	MULTILINE_TEXT,
	EXPRESSION,
	PLACEHOLDER_TEXT,
	COLOR_NO_ALPHA,
	OBJECT_ID,
	TYPE_STRING,
	NODE_PATH_TO_EDITED_NODE,
	OBJECT_TOO_BIG,
	NODE_PATH_VALID_TYPES,
	SAVE_FILE,
	GLOBAL_SAVE_FILE,
	INT_IS_OBJECTID,
	INT_IS_POINTER,
	ARRAY_TYPE,
	LOCALE_ID,
	LOCALIZABLE_STRING,
	NODE_TYPE,
	HIDE_QUATERNION_EDIT,
	PASSWORD,
	LAYERS_AVOIDANCE,
	MAX
}

enum Property_usage {
	NONE = 0,
	STORAGE = 2,
	EDITOR = 4,
	INTERNAL = 8,
	CHECKABLE = 16,
	CHECKED = 32,
	GROUP = 64,
	CATEGORY = 128,
	SUBGROUP = 256,
	CLASS_IS_BITFIELD = 512,
	NO_INSTANCE_STATE = 1024,
	RESTART_IF_CHANGED = 2048,
	SCRIPT_VARIABLE = 4096,
	STORE_IF_NULL = 8192,
	UPDATE_ALL_IF_MODIFIED = 16384,
	SCRIPT_DEFAULT_VALUE = 32768,
	CLASS_IS_ENUM = 65536,
	NIL_IS_VARIANT = 131072,
	ARRAY = 262144,
	ALWAYS_DUPLICATE = 524288,
	NEVER_DUPLICATE = 1048576,
	HIGH_END_GFX = 2097152,
	NODE_PATH_FROM_SCENE_ROOT = 4194304,
	RESOURCE_NOT_PERSISTENT = 8388608,
	KEYING_INCREMENTS = 16777216,
	DEFERRED_SET_RESOURCE = 33554432,
	EDITOR_INSTANTIATE_OBJECT = 67108864,
	EDITOR_BASIC_SETTING = 134217728,
	READ_ONLY = 268435456,
	SECRET = 536870912,
	DEFAULT = 6,
	NO_EDITOR = 2
}

func inspector(var_name: String, var_type: Variable_type = Variable_type.Nil, usage: Property_usage = Property_usage.NONE, hint: Property_hint = Property_hint.NONE, hint_string := "") -> VInspector:
	self.properties.append({
		"name": var_name,
		"type": var_type,
		"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | usage,
		"hint": hint,
		"hint_string": hint_string
	})
	return self

func create_int(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Int) if editable == true else inspector(var_name, Variable_type.Int, Property_usage.READ_ONLY)

func create_float(var_name: String, editable: bool, min_value: float, max_value: float, transition_value:= 0.1) -> VInspector:
	if transition_value >= 1: return inspector(var_name, Variable_type.Float, Property_usage.NONE, Property_hint.RANGE, str(min_value) + "," + str(max_value) + "," + str(0.5)) if editable == true else inspector(var_name, Variable_type.Float, Property_usage.READ_ONLY)
	else: return inspector(var_name, Variable_type.Float, Property_usage.NONE, Property_hint.RANGE, str(min_value) + "," + str(max_value) + "," + str(abs(transition_value))) if editable == true else inspector(var_name, Variable_type.Float, Property_usage.READ_ONLY)

func create_bool(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Bool, Property_usage.UPDATE_ALL_IF_MODIFIED) if editable == true else inspector(var_name, Variable_type.Bool, Property_usage.READ_ONLY)

func create_vector2(var_name: String, editable: bool, intigerize: bool, min_value: float, max_value: float, transition_value:= 0.1) -> VInspector:
	if intigerize: return inspector(var_name, Variable_type.Vector2i, Property_usage.NONE, Property_hint.RANGE, str(min_value) + "," + str(max_value) + "," + str(transition_value)) if editable == true else inspector(var_name, Variable_type.Vector2i, Property_usage.READ_ONLY)
	else: return inspector(var_name, Variable_type.Vector2, Property_usage.NONE, Property_hint.RANGE, str(min_value) + "," + str(max_value) + "," + str(transition_value)) if editable == true else inspector(var_name, Variable_type.Vector2, Property_usage.READ_ONLY)

func create_vector3(var_name: String, editable: bool, intigerize := false) -> VInspector:
	if intigerize: return inspector(var_name, Variable_type.Vector3i) if editable == true else inspector(var_name, Variable_type.Vector3i, Property_usage.READ_ONLY)
	else: return inspector(var_name, Variable_type.Vector3) if editable == true else inspector(var_name, Variable_type.Vector3, Property_usage.READ_ONLY)

func create_vector4(var_name: String, editable: bool, intigerize := false) -> VInspector:
	if intigerize: return inspector(var_name, Variable_type.Vector4i) if editable == true else inspector(var_name, Variable_type.Vector4i, Property_usage.READ_ONLY)
	else: return inspector(var_name, Variable_type.Vector4) if editable == true else inspector(var_name, Variable_type.Vector4, Property_usage.READ_ONLY)

func create_quaternion(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Quaternion) if editable == true else inspector(var_name, Variable_type.Quaternion, Property_usage.READ_ONLY)

func create_basis(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Basis) if editable == true else inspector(var_name, Variable_type.Basis, Property_usage.READ_ONLY)

func create_color(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Color) if editable == true else inspector(var_name, Variable_type.Color, Property_usage.READ_ONLY)

func create_nodepath(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.NodePath) if editable == true else inspector(var_name, Variable_type.NodePath, Property_usage.READ_ONLY)

func create_category(var_name: String, organize_variable_name := false) -> VInspector:
	if organize_variable_name == true:
		self.properties.append({"name": var_name.capitalize(), "type": Variable_type.Nil, "usage": Property_usage.CATEGORY})
		return self
	self.properties.append({"name": var_name, "type": Variable_type.Nil, "usage": Property_usage.CATEGORY})
	return self

func create_group(var_name: String, filter := "") -> VInspector:
	self.properties.append({"name": var_name, "type": Variable_type.Nil, "usage": Property_usage.GROUP, "hint_string": filter})
	return self

func create_subgroup(var_name: String, filter := "") -> VInspector:
	self.properties.append({"name": var_name, "type": Variable_type.Nil, "usage": Property_usage.SUBGROUP, "hint_string": filter})
	return self

func create_resource(var_name: String, editable: bool, searching: bool) -> VInspector:
	if searching: return inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT, Property_hint.NONE) if editable else inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT | Property_usage.READ_ONLY, Property_hint.NONE)
	else: return inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT, Property_hint.RESOURCE_TYPE) if editable else inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT | Property_usage.READ_ONLY, Property_hint.RESOURCE_TYPE)

func create_text(var_name: String, editable: bool, multiline_text := false, string_name := false) -> VInspector:
	if !string_name: return inspector(var_name, Variable_type.String, Property_usage.NONE, Property_hint.MULTILINE_TEXT) if multiline_text else inspector(var_name, Variable_type.String, Property_usage.NONE)
	else: return inspector(var_name, Variable_type.StringName, Property_usage.NONE, Property_hint.MULTILINE_TEXT) if multiline_text else inspector(var_name, Variable_type.StringName, Property_usage.NONE)

func create_enum(var_name: String, enum_var: Dictionary, editable: bool, include_values := true, organize_words := false) -> VInspector:
	if editable: return inspector(var_name, Variable_type.Int, Property_usage.UPDATE_ALL_IF_MODIFIED, Property_hint.ENUM, enum2str(enum_var, include_values, organize_words))
	else: return inspector(var_name, Variable_type.Int, Property_usage.READ_ONLY, Property_hint.ENUM, enum2str(enum_var, include_values, organize_words))

func create_flags(var_name: String, enum_flag: Dictionary, editable: bool, include_values := true, capitalize_words := false) -> VInspector:
	if editable: return inspector(var_name, Variable_type.Int, Property_usage.UPDATE_ALL_IF_MODIFIED, Property_hint.FLAGS, enum2str(enum_flag, include_values, capitalize_words))
	else: return inspector(var_name, Variable_type.Int, Property_usage.READ_ONLY, Property_hint.FLAGS, enum2str(enum_flag, include_values, capitalize_words))

func create_typed_nodepath(var_name: String, node: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.NodePath, Property_usage.NONE, Property_hint.NODE_PATH_VALID_TYPES, node) if editable else inspector(var_name, Variable_type.NodePath, Property_usage.READ_ONLY, Property_hint.NODE_PATH_VALID_TYPES, node)

func create_object(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT) if editable else inspector(var_name, Variable_type.Object, Property_usage.NODE_PATH_FROM_SCENE_ROOT | Property_usage.READ_ONLY)

func create_json_file(var_name: String, editable: bool) -> VInspector:
	return inspector(var_name, Variable_type.Object, Property_usage.DEFAULT | Property_usage.EDITOR_INSTANTIATE_OBJECT | Property_usage.STORAGE | Property_usage.UPDATE_ALL_IF_MODIFIED, Property_hint.RESOURCE_TYPE, "JSON") if editable else inspector(var_name, Variable_type.Object, Property_usage.DEFAULT | Property_usage.EDITOR_INSTANTIATE_OBJECT | Property_usage.READ_ONLY)

func create_collision_resource(var_name: String, editable: bool, searching: bool) -> VInspector:
	if searching: return inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT, Property_hint.RESOURCE_TYPE, "CircleShape2D, RectangleShape2D, CapsuleShape2D") if editable else inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT | Property_usage.READ_ONLY)
	else: return inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT, Property_hint.RESOURCE_TYPE, "CircleShape2D, RectangleShape2D, CapsuleShape2D") if editable else inspector(var_name, Variable_type.Object, Property_usage.EDITOR_INSTANTIATE_OBJECT | Property_usage.READ_ONLY, Property_hint.RESOURCE_TYPE)

func create_collision_layer(var_namee: String, editable: bool) -> VInspector:
	return inspector(var_namee, Variable_type.Int, Property_usage.CLASS_IS_BITFIELD, Property_hint.LAYERS_2D_RENDER)
