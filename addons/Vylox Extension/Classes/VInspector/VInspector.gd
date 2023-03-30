@icon("res://addons/Vylox Extension/Classes/VInspector/VInspector.svg")
class_name VInspector
extends RefCounted

@export var properties: Array

enum {
    PROPERTY_HINT_OBJECT_ID=23,
    PROPERTY_HINT_TYPE_STRING,
    PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE,
    PROPERTY_HINT_METHOD_OF_VARIANT_TYPE,
    PROPERTY_HINT_METHOD_OF_BASE_TYPE,
    PROPERTY_HINT_METHOD_OF_INSTANCE,
    PROPERTY_HINT_METHOD_OF_SCRIPT,
    PROPERTY_HINT_PROPERTY_OF_VARIANT_TYPE,
    PROPERTY_HINT_PROPERTY_OF_BASE_TYPE,
    PROPERTY_HINT_PROPERTY_OF_INSTANCE,
    PROPERTY_HINT_PROPERTY_OF_SCRIPT,
    PROPERTY_HINT_OBJECT_TOO_BIG,
    PROPERTY_HINT_NODE_PATH_VALID_TYPES,
}

static func enum2str(enum_dict: Dictionary, include_values: bool = false) -> String:
    var enum_string = ""
    if include_values:
        for k in enum_dict.keys():
            enum_string += k.capitalize() + ":" + str(enum_dict[k]) + ","
    else:
        for k in enum_dict.keys():
            enum_string += k.capitalize() + ","
    if enum_string.length() > 0:
        enum_string = enum_string.substr(0, enum_string.length() - 1)
    return enum_string

func create_int(var_name: String, hint_string := "") -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_INT,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "hint_string": hint_string
    })
    return self

func create_float(var_name: String, min_value : float, max_value : float, transition_value:= 0.1) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_FLOAT,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "hint": PROPERTY_HINT_RANGE,
        "hint_string": str(min_value) + "," + str(max_value) + "," + str(transition_value)
    })
    return self

func create_bool(var_name: String, hint_string := "", extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_BOOL,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
        "hint_string": hint_string
    })
    return self

func create_vector2(var_name: String, drag_visual:= false, hint_string := "") -> VInspector:
    if drag_visual == true:
        self.properties.append({
            "name": var_name,
            "type": TYPE_VECTOR2I,
            "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
            "hint_string": hint_string
        })
    if drag_visual == false:
        self.properties.append({
            "name": var_name,
            "type": TYPE_VECTOR2,
            "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
            "hint_string": hint_string
        })
    return self

func create_3x3(var_name: String, hint_string := "") -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_BASIS,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "hint_string": hint_string
    })
    return self

func create_color(var_name: String, hint_string := "") -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_COLOR,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "hint_string": hint_string
    })
    return self

func create_node_path(var_name: String, hint_string := "") -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_NODE_PATH,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE,
        "hint_string": hint_string
    })
    return self

func create_category(category_name: String) -> VInspector:
    self.properties.append({
        "name": category_name,
        "type": TYPE_NIL,
        "usage": PROPERTY_USAGE_CATEGORY
    })
    return self

func create_group(group_name: String, hint_string := "") -> VInspector:
    self.properties.append({
        "name": group_name,
        "type": TYPE_NIL,
        "hint_string": hint_string,
        "usage": PROPERTY_USAGE_GROUP
    })
    return self

func create_resource(var_name: String, resource_name: String, extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_OBJECT,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage,
        "hint": PROPERTY_HINT_RESOURCE_TYPE,
        "hint_string": resource_name
    })
    return self

func create_text(var_name: String, extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_STRING,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage,
        "hint": PROPERTY_HINT_MULTILINE_TEXT
    })
    return self

func create_enum(var_name: String, enum_: Dictionary, extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_INT,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage | PROPERTY_USAGE_UPDATE_ALL_IF_MODIFIED,
        "hint": PROPERTY_HINT_ENUM,
        "hint_string": enum2str(enum_, true)
    })
    return self

func create_flags(var_name: String, enum_flag: Dictionary, extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_INT,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage,
        "hint": PROPERTY_HINT_FLAGS,
        "hint_string": enum2str(enum_flag)
    })
    return self

func create_typed_array(var_name: String, hint: Array, extra_usage := 0) -> VInspector:
    assert(hint.size() >= 2, "Hint parameter need to have 2 index or more")
    var hint_string := ""

    for _i in hint[0] - 1:
        hint_string += "19:"
    
    hint_string += str(hint[1])

    if hint.size() == 2:
        hint_string += ":"
    else:
        hint_string += "/" + str(hint[2]) + ":"

        if hint.size() > 3:
            for i in range(3, hint.size()):
                match typeof(hint[i]):
                    TYPE_INT:
                        hint_string += str(hint[i]) + ","
                    TYPE_STRING:
                        hint_string += hint[i] + ","
                    _:
                        assert(false, "Hint parameter array can be only int and String")
            
            hint_string.substr(0, hint_string.length() - 1)
    
    return self.create_typed_array_s(var_name, hint_string, extra_usage)

func create_typed_array_s(var_name: String, hint_string: String, extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_ARRAY,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage,
        "hint": PROPERTY_HINT_TYPE_STRING,
        "hint_string": hint_string
    })
    return self

func create_typed_nodepath(var_name: String, node: String, extra_usage := 0) -> VInspector:
    self.properties.append({
        "name": var_name,
        "type": TYPE_NODE_PATH,
        "usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE | extra_usage,
        "hint": PROPERTY_HINT_NODE_PATH_VALID_TYPES,
        "hint_string": node
    })
    return self
