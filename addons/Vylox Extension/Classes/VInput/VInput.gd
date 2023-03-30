@tool
@icon("res://addons/Vylox Extension/Classes/VInput/VInput.svg")
extends RefCounted
class_name VInput

## Tool for Vylox Classes, such as VCharacter2D or VObject2D.
## The Class, that has access to VInput can utilize VInput's
## mouse / keyboard / controller actions and it's behaviours
## in game or at the editor directly. (Functions, which needs
## in game interaction will only run in game.) 

static func mouse_left_pressed(): return Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
static func mouse_right_pressed(): return Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
static func mouse_middle_pressed(): return Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)
static func mouse_mouse4_pressed(): return Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON1)
static func mouse_mouse5_pressed(): return Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON2)

static func mouse_left_released(): return !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
static func mouse_right_released(): return !Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)
static func mouse_middle_released(): return !Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)
static func mouse_mouse4_released(): return !Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON1)
static func mouse_mous5_released(): return !Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON2)

static func mouse_left_just_pressed():
    
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)

static func mouse_right_just_pressed():
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)

static func mouse_middle_just_pressed():
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE)

static func mouse_mouse4_just_pressed():
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON1)

static func mouse_mouse5_just_pressed():
    return Input.is_mouse_button_pressed(MOUSE_BUTTON_XBUTTON2)
