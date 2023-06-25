@tool
extends Node
class_name VInput

## Before using VInput, please set your own prefered configuration, regarding Mouse Delay (for how long should
## any Mouse Action be Pressed), Mouse doubleclick amount (A limit on how much presses it takes to trigger a doubleclick)
## and Mouse doubleclick time (Triggering doubleclick within this Time frame).
## [br][br]
## Use set_delay() and set_doubleclick() functions on your project, or do it inside VInput!
## [br]
## You can access VInput's enum or variables by using an Autoloaded method: "VInput.x"! ("x" can be the "last_current_mouse_press" variable for example.)
## [br][br]
## Example: VInput.set_delay(VInput.last_current_mouse_press, 2) | VInput.set_doubleclick(VInput.last_current_mouse_press, 2, 0.5)

enum Mouse_button {
	NONE = 0,
	LEFT = 1,
	RIGHT = 2,
	MIDDLE = 3,
	WHEEL_UP = 4,
	WHEEL_DOWN = 5,
	WHEEL_LEFT = 6,
	WHEEL_RIGHT = 7,
	XBUTTON1 = 8,
	XBUTTON2 = 9
}

enum Keyboard_button {
	NONE = 0,
	SPECIAL = 4194304,
	ESCAPE = 4194305,
	TAB = 4194306,
	BACKTAB = 4194307,
	BACKSPACE = 4194308,
	ENTER = 4194309,
	KP_ENTER = 4194310,
	INSERT = 4194311,
	DELETE = 4194312,
	PAUSE = 4194313,
	PRINT = 4194314,
	SYSREQ = 4194315,
	CLEAR = 4194316,
	HOME = 4194317,
	END = 4194318,
	LEFT = 4194319,
	UP = 4194320,
	RIGHT = 4194321,
	DOWN = 4194322,
	PAGEUP = 4194323,
	PAGEDOWN = 4194324,
	SHIFT = 4194325,
	CTRL = 4194326,
	META = 4194327,
	ALT = 4194328,
	CAPSLOCK = 4194329,
	NUMLOCK = 4194330,
	SCROLLLOCK = 4194331,
	F1 = 4194332,
	F2 = 4194333,
	F3 = 4194334,
	F4 = 4194335,
	F5 = 4194336,
	F6 = 4194337,
	F7 = 4194338,
	F8 = 4194339,
	F9 = 4194340,
	F10 = 4194341,
	F11 = 4194342,
	F12 = 4194343,
	F13 = 4194344,
	F14 = 4194345,
	F15 = 4194346,
	F16 = 4194347,
	F17 = 4194348,
	F18 = 4194349,
	F19 = 4194350,
	F20 = 4194351,
	F21 = 4194352,
	F22 = 4194353,
	F23 = 4194354,
	F24 = 4194355,
	F25 = 4194356,
	F26 = 4194357,
	F27 = 4194358,
	F28 = 4194359,
	F29 = 4194360,
	F30 = 4194361,
	F31 = 4194362,
	F32 = 4194363,
	F33 = 4194364,
	F34 = 4194365,
	F35 = 4194366,
	KP_MULTIPLY = 4194433,
	KP_DIVIDE = 4194434,
	KP_SUBTRACT = 4194435,
	KP_PERIOD = 4194436,
	KP_ADD = 4194437,
	KP_0 = 4194438,
	KP_1 = 4194439,
	KP_2 = 4194440,
	KP_3 = 4194441,
	KP_4 = 4194442,
	KP_5 = 4194443,
	KP_6 = 4194444,
	KP_7 = 4194445,
	KP_8 = 4194446,
	KP_9 = 4194447,
	MENU = 4194370,
	HYPER = 4194371,
	HELP = 4194373,
	BACK = 4194376,
	FORWARD = 4194377,
	STOP = 4194378,
	REFRESH = 4194379,
	VOLUMEDOWN = 4194380,
	VOLUMEMUTE = 4194381,
	VOLUMEUP = 4194382,
	MEDIAPLAY = 4194388,
	MEDIASTOP = 4194389,
	MEDIAPREVIOUS = 4194390,
	MEDIANEXT = 4194391,
	MEDIARECORD = 4194392,
	HOMEPAGE = 4194393,
	FAVORITES = 4194394,
	SEARCH = 4194395,
	STANDBY = 4194396,
	OPENURL = 4194397,
	LAUNCHMAIL = 4194398,
	LAUNCHMEDIA = 4194399,
	LAUNCH0 = 4194400,
	LAUNCH1 = 4194401,
	LAUNCH2 = 4194402,
	LAUNCH3 = 4194403,
	LAUNCH4 = 4194404,
	LAUNCH5 = 4194405,
	LAUNCH6 = 4194406,
	LAUNCH7 = 4194407,
	LAUNCH8 = 4194408,
	LAUNCH9 = 4194409,
	LAUNCHA = 4194410,
	LAUNCHB = 4194411,
	LAUNCHC = 4194412,
	LAUNCHD = 4194413,
	LAUNCHE = 4194414,
	LAUNCHF = 4194415,
	UNKNOWN = 8388607,
	SPACE = 32,
	EXCLAM = 33,
	QUOTEDBL = 34,
	NUMBERSIGN = 35,
	DOLLAR = 36,
	PERCENT = 37,
	AMPERSAND = 38,
	APOSTROPHE = 39,
	PARENLEFT = 40,
	PARENRIGHT = 41,
	ASTERISK = 42,
	PLUS = 43,
	COMMA = 44,
	MINUS = 45,
	PERIOD = 46,
	SLASH = 47,
	NUMBER_0 = 48,
	NUMBER_1 = 49,
	NUMBER_2 = 50,
	NUMBER_3 = 51,
	NUMBER_4 = 52,
	NUMBER_5 = 53,
	NUMBER_6 = 54,
	NUMBER_7 = 55,
	NUMBER_8 = 56,
	NUMBER_9 = 57,
	COLON = 58,
	SEMICOLON = 59,
	LESS = 60,
	EQUAL = 61,
	GREATER = 62,
	QUESTION = 63,
	AT = 64,
	A = 65,
	B = 66,
	C = 67,
	D = 68,
	E = 69,
	F = 70,
	G = 71,
	H = 72,
	I = 73,
	J = 74,
	K = 75,
	L = 76,
	M = 77,
	N = 78,
	O = 79,
	P = 80,
	Q = 81,
	R = 82,
	S = 83,
	T = 84,
	U = 85,
	V = 86,
	W = 87,
	X = 88,
	Y = 89,
	Z = 90,
	BRACKETLEFT = 91,
	BACKSLASH = 92,
	BRACKETRIGHT = 93,
	ASCIICIRCUM = 94,
	UNDERSCORE = 95,
	QUOTELEFT = 96,
	BRACELEFT = 123,
	BAR = 124,
	BRACERIGHT = 125,
	ASCIITILDE = 126,
	YEN = 165,
	SECTION = 167,
	GLOBE = 4194416,
	KEYBOARD = 4194417,
	JIS_EISU = 4194418,
	JIS_KANA = 4194419
}


enum enum_keyboard_action {JustPressed, JustHeld, Held}


# Actions recorded for each Mouse Button. Their values can be seen through "enum_mouse_action".
# When any variable updates it's value, then it sends a signal with the appropriate name.
enum enum_mouse_action {JustPressed, Pressed, JustHeld, Held, JustReleased, Released, Doubleclicked}
var mouse_left_action: int = enum_mouse_action.Released:
	set(value):
		mouse_left_action = value
		mouse_left_action = clamp(mouse_left_action, 0, enum_mouse_action.keys().size())
		if mouse_left_action == enum_mouse_action.JustPressed: return mouse_left_just_pressed()
		if mouse_left_action == enum_mouse_action.Pressed: return mouse_left_pressed()
		if mouse_left_action == enum_mouse_action.JustHeld: return mouse_left_just_held()
		if mouse_left_action == enum_mouse_action.Held: return mouse_left_held()
		if mouse_left_action == enum_mouse_action.JustReleased: return mouse_left_just_released()
		if mouse_left_action == enum_mouse_action.Released: return mouse_left_released()
var mouse_right_action: int = enum_mouse_action.Released:
	set(value):
		mouse_right_action = value
		mouse_right_action = clamp(mouse_right_action, 0, enum_mouse_action.keys().size())
		if mouse_right_action == enum_mouse_action.JustPressed: return mouse_right_just_pressed()
		if mouse_right_action == enum_mouse_action.Pressed: return mouse_right_pressed()
		if mouse_right_action == enum_mouse_action.JustHeld: return mouse_right_just_held()
		if mouse_right_action == enum_mouse_action.Held: return mouse_right_held()
		if mouse_right_action == enum_mouse_action.JustReleased: return mouse_right_just_released()
		if mouse_right_action == enum_mouse_action.Released: return mouse_right_released()
var mouse_middle_action: int = enum_mouse_action.Released:
	set(value):
		mouse_middle_action = value
		mouse_middle_action = clamp(mouse_middle_action, 0, enum_mouse_action.keys().size())
		if mouse_middle_action == enum_mouse_action.JustPressed: return mouse_middle_just_pressed()
		if mouse_middle_action == enum_mouse_action.Pressed: return mouse_middle_pressed()
		if mouse_middle_action == enum_mouse_action.JustHeld: return mouse_middle_just_held()
		if mouse_middle_action == enum_mouse_action.Held: return mouse_middle_held()
		if mouse_middle_action == enum_mouse_action.JustReleased: return mouse_middle_just_released()
		if mouse_middle_action == enum_mouse_action.Released: return mouse_middle_released()
var mouse_wheelup_action: int = enum_mouse_action.Released:
	set(value):
		mouse_wheelup_action = value
		mouse_wheelup_action = clamp(mouse_wheelup_action, 0, enum_mouse_action.keys().size())
		if mouse_wheelup_action == enum_mouse_action.JustPressed: return mouse_wheelup_just_pressed()
		if mouse_wheelup_action == enum_mouse_action.JustReleased: return mouse_wheelup_just_released()
		if mouse_wheelup_action == enum_mouse_action.Released: return mouse_wheelup_released()
var mouse_wheeldown_action: int = enum_mouse_action.Released:
	set(value):
		mouse_wheeldown_action = value
		mouse_wheeldown_action = clamp(mouse_wheeldown_action, 0, enum_mouse_action.keys().size())
		if mouse_wheeldown_action == enum_mouse_action.JustPressed: return mouse_wheeldown_just_pressed()
		if mouse_wheeldown_action == enum_mouse_action.JustReleased: return mouse_wheeldown_just_released()
		if mouse_wheeldown_action == enum_mouse_action.Released: return mouse_wheeldown_released()
var mouse_wheelleft_action: int = enum_mouse_action.Released:
	set(value):
		mouse_wheelleft_action = value
		mouse_wheelleft_action = clamp(mouse_wheelleft_action, 0, enum_mouse_action.keys().size())
		if mouse_wheelleft_action == enum_mouse_action.JustPressed: return mouse_wheelleft_just_pressed()
		if mouse_wheelleft_action == enum_mouse_action.JustReleased: return mouse_wheelleft_just_released()
		if mouse_wheelleft_action == enum_mouse_action.Released: return mouse_wheelleft_released()
var mouse_wheelright_action: int = enum_mouse_action.Released:
	set(value):
		mouse_wheelright_action = value
		mouse_wheelright_action = clamp(mouse_wheelright_action, 0, enum_mouse_action.keys().size())
		if mouse_wheelright_action == enum_mouse_action.JustPressed: return mouse_wheelright_just_pressed()
		if mouse_wheelright_action == enum_mouse_action.JustReleased: return mouse_wheelright_just_released()
		if mouse_wheelright_action == enum_mouse_action.Released: return mouse_wheelright_released()
var mouse_xbutton1_action: int = enum_mouse_action.Released:
	set(value):
		mouse_xbutton1_action = value
		mouse_xbutton1_action = clamp(mouse_xbutton1_action, 0, enum_mouse_action.keys().size())
		if mouse_xbutton1_action == enum_mouse_action.JustPressed: return mouse_xbutton1_just_pressed()
		if mouse_xbutton1_action == enum_mouse_action.Pressed: return mouse_xbutton1_pressed()
		if mouse_xbutton1_action == enum_mouse_action.JustHeld: return mouse_xbutton1_just_held()
		if mouse_xbutton1_action == enum_mouse_action.Held: return mouse_xbutton1_held()
		if mouse_xbutton1_action == enum_mouse_action.JustReleased: return mouse_xbutton1_just_released()
		if mouse_xbutton1_action == enum_mouse_action.Released: return mouse_xbutton1_released()
var mouse_xbutton2_action: int = enum_mouse_action.Released:
	set(value):
		mouse_xbutton2_action = value
		mouse_xbutton2_action = clamp(mouse_xbutton2_action, 0, enum_mouse_action.keys().size())
		if mouse_xbutton2_action == enum_mouse_action.JustPressed: return mouse_xbutton2_just_pressed()
		if mouse_xbutton2_action == enum_mouse_action.Pressed: return mouse_xbutton2_pressed()
		if mouse_xbutton2_action == enum_mouse_action.JustHeld: return mouse_xbutton2_just_held()
		if mouse_xbutton2_action == enum_mouse_action.Held: return mouse_xbutton2_held()
		if mouse_xbutton2_action == enum_mouse_action.JustReleased: return mouse_xbutton2_just_released()
		if mouse_xbutton2_action == enum_mouse_action.Released: return mouse_xbutton2_released()
var mouse_action_doubleclicked: Array = [false, false, false, false, false, false, false, false, false, false]

func mouse_left_just_pressed() -> bool:			return true if mouse_left_action == enum_mouse_action.JustPressed else false
func mouse_left_pressed() -> bool:				return true if mouse_left_action == enum_mouse_action.Pressed else false
func mouse_left_just_held() -> bool:			return true if mouse_left_action == enum_mouse_action.JustHeld else false
func mouse_left_held() -> bool:					return true if mouse_left_action == enum_mouse_action.Held else false
func mouse_left_just_released() -> bool:		return true if mouse_left_action == enum_mouse_action.JustReleased else false
func mouse_left_released() -> bool:				return true if mouse_left_action == enum_mouse_action.Released else false
func mouse_left_doubleclicked() -> bool:		return mouse_action_doubleclicked[Mouse_button.LEFT]

func mouse_right_just_pressed() -> bool:		return true if mouse_right_action == enum_mouse_action.JustPressed else false
func mouse_right_pressed() -> bool:				return true if mouse_right_action == enum_mouse_action.Pressed else false
func mouse_right_just_held() -> bool:			return true if mouse_right_action == enum_mouse_action.JustHeld else false
func mouse_right_held() -> bool:				return true if mouse_right_action == enum_mouse_action.Held else false
func mouse_right_just_released() -> bool:		return true if mouse_right_action == enum_mouse_action.JustReleased else false
func mouse_right_released() -> bool:			return true if mouse_right_action == enum_mouse_action.Released else false
func mouse_right_doubleclicked() -> bool:		return mouse_action_doubleclicked[Mouse_button.RIGHT]

func mouse_middle_just_pressed() -> bool:		return true if mouse_middle_action == enum_mouse_action.JustPressed else false
func mouse_middle_pressed() -> bool:			return true if mouse_middle_action == enum_mouse_action.Pressed else false
func mouse_middle_just_held() -> bool:			return true if mouse_middle_action == enum_mouse_action.JustHeld else false
func mouse_middle_held() -> bool:				return true if mouse_middle_action == enum_mouse_action.Held else false
func mouse_middle_just_released() -> bool:		return true if mouse_middle_action == enum_mouse_action.JustReleased else false
func mouse_middle_released() -> bool:			return true if mouse_middle_action == enum_mouse_action.Released else false
func mouse_middle_doubleclicked() -> bool:		return mouse_action_doubleclicked[Mouse_button.MIDDLE]

func mouse_wheelup_just_pressed() -> bool:		return true if mouse_wheelup_action == enum_mouse_action.JustPressed else false
func mouse_wheelup_just_released() -> bool:		return true if mouse_wheelup_action == enum_mouse_action.JustReleased else false
func mouse_wheelup_released() -> bool:			return true if mouse_wheelup_action == enum_mouse_action.Released else false
func mouse_wheelup_doubleclicked() -> bool:		return mouse_action_doubleclicked[Mouse_button.WHEEL_UP]

func mouse_wheeldown_just_pressed() -> bool:	return true if mouse_wheeldown_action == enum_mouse_action.JustPressed else false
func mouse_wheeldown_just_released() -> bool:	return true if mouse_wheeldown_action == enum_mouse_action.JustReleased else false
func mouse_wheeldown_released() -> bool:		return true if mouse_wheeldown_action == enum_mouse_action.Released else false
func mouse_wheeldown_doubleclicked() -> bool:	return mouse_action_doubleclicked[Mouse_button.WHEEL_DOWN]

func mouse_wheelleft_just_pressed() -> bool:	return true if mouse_wheelleft_action == enum_mouse_action.JustPressed else false
func mouse_wheelleft_just_released() -> bool:	return true if mouse_wheelleft_action == enum_mouse_action.JustReleased else false
func mouse_wheelleft_released() -> bool:		return true if mouse_wheelleft_action == enum_mouse_action.Released else false
func mouse_wheelleft_doubleclicked() -> bool:	return mouse_action_doubleclicked[Mouse_button.WHEEL_LEFT]

func mouse_wheelright_just_pressed() -> bool:	return true if mouse_wheelright_action == enum_mouse_action.JustPressed else false
func mouse_wheelright_just_released() -> bool:	return true if mouse_wheelright_action == enum_mouse_action.JustReleased else false
func mouse_wheelright_released() -> bool:		return true if mouse_wheelright_action == enum_mouse_action.Released else false
func mouse_wheelright_doubleclicked() -> bool:	return mouse_action_doubleclicked[Mouse_button.WHEEL_RIGHT]

func mouse_xbutton1_just_pressed() -> bool: 	return true if mouse_xbutton1_action == enum_mouse_action.JustPressed else false
func mouse_xbutton1_pressed() -> bool: 			return true if mouse_xbutton1_action == enum_mouse_action.Pressed else false
func mouse_xbutton1_just_held() -> bool: 		return true if mouse_xbutton1_action == enum_mouse_action.JustHeld else false
func mouse_xbutton1_held() -> bool: 			return true if mouse_xbutton1_action == enum_mouse_action.Held else false
func mouse_xbutton1_just_released() -> bool: 	return true if mouse_xbutton1_action == enum_mouse_action.JustReleased else false
func mouse_xbutton1_released() -> bool: 		return true if mouse_xbutton1_action == enum_mouse_action.Released else false
func mouse_xbutton1_doubleclicked() -> bool: 	return mouse_action_doubleclicked[Mouse_button.XBUTTON1]

func mouse_xbutton2_just_pressed() -> bool: 	return true if mouse_xbutton2_action == enum_mouse_action.JustPressed else false
func mouse_xbutton2_pressed() -> bool: 			return true if mouse_xbutton2_action == enum_mouse_action.Pressed else false
func mouse_xbutton2_just_held() -> bool: 		return true if mouse_xbutton2_action == enum_mouse_action.JustHeld else false
func mouse_xbutton2_held() -> bool: 			return true if mouse_xbutton2_action == enum_mouse_action.Held else false
func mouse_xbutton2_just_released() -> bool: 	return true if mouse_xbutton2_action == enum_mouse_action.JustReleased else false
func mouse_xbutton2_released() -> bool: 		return true if mouse_xbutton2_action == enum_mouse_action.Released else false
func mouse_xbutton2_doubleclicked() -> bool: 	return mouse_action_doubleclicked[Mouse_button.XBUTTON2]

# Used to calculate time required to trigger a double click for each Mouse Button.
var mouse_current_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0]

# Used to calculate amount of clicks required to trigger a double click for each Mouse Button.
var mouse_current_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0,0]

# Limits the amount of time required to trigger a double click within that time frame.
# Note, this variable is not responsible for the current time spent, it just records the triggerable
# time frame.
var mouse_doubleclick_limit_time: PackedFloat64Array = [0,2,0,0,0,0,0,0,0,0]

# Limits the amount of clicks required for a double click to trigger for each Mouse Button.
var mouse_doubleclick_limit_amount: PackedFloat64Array = [0,2,0,0,0,0,0,0,0,0]

# The actual delay for each Mouse Button, separated but accessible in one variable.
# You can use get_delay() and set_delay() to interact with mouse_delay.
var mouse_delay: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0]

# Records all Mouse Button Actions, which can be in InputEventMouseButton.
# Numbers are recognizable with "Mouse_button" enum and "mouse_index". Whatever index it is,
# it'll record it's action on that position.
var array_mouse_press: PackedInt64Array = [0,0,0,0,0,0,0,0,0,0]

# Records all Delay values for all possible Mouse Buttons, which can be in InputEventMouseButton.
# Numbers are recognizable with "Mouse_button" enum and "mouse_index". Whatever index it is, it'll
# record that button's delay on that position.
var array_mouse_delay: PackedFloat64Array = [0,1,0,0,0,0,0,0,0,0]

# The current Mouse Button action, which can be in InputEventMouseButton.
var last_current_mouse_press: int

# The current Keyboard Button action, which can be in InputEvent
var last_current_keyboard_press:
	set(value):
		last_current_keyboard_press = value
		print(value)

# Set the Pressed delay of the Mouse Button. Can be called with "Mouse_button" enum.
func set_delay(current_button, amount: float):
	if current_button is Mouse_button: mouse_delay[current_button] = amount
	

# Get the Pressed delay of the Mouse Button. Can be called with "Mouse_button" enum.
func get_delay(current_mouse_button) -> float:
	return mouse_delay[current_mouse_button]

func get_all_actions() -> Array:
	var all_actions: Array = [mouse_left_action, mouse_right_action, mouse_middle_action, mouse_wheelup_action, mouse_wheeldown_action, mouse_wheelleft_action, mouse_wheelright_action, mouse_xbutton1_action, mouse_xbutton2_action]
	return all_actions

# Set the Max amount and Max time frame of the Mouse Button's Double click properties.
# Can be called with "Mouse_button" enum.
func set_doubleclick(current_mouse_button: Mouse_button, amount: float, time_frame: float):
	mouse_doubleclick_limit_amount[current_mouse_button] = amount
	mouse_doubleclick_limit_time[current_mouse_button] = time_frame

# Get the Max amount, Max time frame, Double clicked, Current amount and Current time frame of the Mouse Button's
# Double click properties. Can be called with "Mouse_button" enum.
func get_doubleclick(current_mouse_button: Mouse_button) -> Array:
	var calc: Array = [
		mouse_doubleclick_limit_amount[current_mouse_button], 
		mouse_doubleclick_limit_time[current_mouse_button], 
		mouse_action_doubleclicked[current_mouse_button], 
		mouse_current_doubleclick_amount[current_mouse_button], 
		mouse_current_doubleclick_time[current_mouse_button]]
	return calc

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			last_current_mouse_press = event.button_index
			array_mouse_press[event.button_index] = 1
		if event.is_released():
			array_mouse_press[event.button_index] = 0
	if event is InputEventKey:
		if event.is_pressed():
			last_current_keyboard_press = event.keycode
		if event.is_released():
			last_current_keyboard_press = 0

## [b]VInput Specific function.[/b][br][br] Turns any Mouse Button (relative to position in [b]Mouse_button[/b] enum) into their respective Mouse Action variables
## And return that instead. Can be used with [b]last_current_mouse_press[/b] variable.
func button2action(position):
	match position:
		Mouse_button.LEFT: return mouse_left_action
		Mouse_button.RIGHT: return mouse_right_action
		Mouse_button.MIDDLE: return mouse_middle_action
		Mouse_button.WHEEL_UP: return mouse_wheelup_action
		Mouse_button.WHEEL_DOWN: return mouse_wheeldown_action
		Mouse_button.WHEEL_LEFT: return mouse_wheelleft_action
		Mouse_button.WHEEL_RIGHT: return mouse_wheelright_action
		Mouse_button.XBUTTON1: return mouse_xbutton1_action
		Mouse_button.XBUTTON2: return mouse_xbutton2_action

## [b]Controls process in a way, that when you call it, it lets VInput calculate Inputs.[/b][br][br] If the function is not called, then VInput's calculations won't run. Useful to let a Script control when to calculate Inputs, increasing performance. If you don't care about performance, then you can call this function inside _process(delta) or _physics_process(delta) functions.
func VInput_work(delta):
	mouse_action_calc(button2action(last_current_mouse_press), last_current_mouse_press, array_mouse_press[last_current_mouse_press], delta)

func mouse_button_apply(from_index: int, what_action):
	match from_index:
		Mouse_button.LEFT: mouse_left_action = what_action
		Mouse_button.RIGHT: mouse_right_action = what_action
		Mouse_button.MIDDLE: mouse_middle_action = what_action
		Mouse_button.WHEEL_UP: mouse_wheelup_action = what_action
		Mouse_button.WHEEL_DOWN: mouse_wheeldown_action = what_action
		Mouse_button.WHEEL_LEFT: mouse_wheelleft_action = what_action
		Mouse_button.WHEEL_RIGHT: mouse_wheelright_action = what_action
		Mouse_button.XBUTTON1: mouse_xbutton1_action = what_action
		Mouse_button.XBUTTON2: mouse_xbutton2_action = what_action

func mouse_doubleclick_apply(from_index: int, active: bool):
	call_doubleclicking_functions(from_index)
	mouse_current_doubleclick_amount[from_index] = 0
	mouse_current_doubleclick_time[from_index] = 0
	if mouse_action_doubleclicked[from_index] != active: mouse_action_doubleclicked[from_index] = active

func mouse_action_calc(action, position, pressed, delta):
	mouse_doubleclick_action_calc(action, position, delta)
	if pressed:
		# Just Pressed
		if action == enum_mouse_action.JustReleased or action == enum_mouse_action.Released:
			# Apply Mouse Delay
			if array_mouse_delay[position] != mouse_delay[position]: array_mouse_delay[position] = mouse_delay[position]
			return mouse_button_apply(position, enum_mouse_action.JustPressed)
		
		# Mouse Delay Calculation
		if array_mouse_delay[position] > 0:
			array_mouse_delay[position] -= delta
			array_mouse_delay[position] = clamp(array_mouse_delay[position], 0, mouse_delay[position])
			
			# Pressed
			return mouse_button_apply(position, enum_mouse_action.Pressed)
		
		if array_mouse_delay[position] == 0 or mouse_delay[position] == 0:
			# Just Held
			if action != enum_mouse_action.JustHeld and action != enum_mouse_action.Held:
				return mouse_button_apply(position, enum_mouse_action.JustHeld)
			
			# Held
			return mouse_button_apply(position, enum_mouse_action.Held)
	if !pressed:
		# Reset Mouse Delay
		array_mouse_delay[position] = 0
		
		# Just Released
		if action != enum_mouse_action.JustReleased and action != enum_mouse_action.Released:
			return mouse_button_apply(position, enum_mouse_action.JustReleased)
		
		# Released
		return mouse_button_apply(position, enum_mouse_action.Released)

func call_doubleclicking_functions(position):
	match position:
		Mouse_button.LEFT: return mouse_left_doubleclicked()
		Mouse_button.RIGHT: return mouse_right_doubleclicked()
		Mouse_button.MIDDLE: return mouse_middle_doubleclicked()
		Mouse_button.WHEEL_UP: return mouse_wheelup_doubleclicked()
		Mouse_button.WHEEL_DOWN: return mouse_wheeldown_doubleclicked()
		Mouse_button.WHEEL_LEFT: return mouse_wheelleft_doubleclicked()
		Mouse_button.WHEEL_RIGHT: return mouse_wheelright_doubleclicked()
		Mouse_button.XBUTTON1: return mouse_xbutton1_doubleclicked()
		Mouse_button.XBUTTON2: return mouse_xbutton2_doubleclicked()

func mouse_doubleclick_action_calc(action, position, delta):
	if action == enum_mouse_action.JustPressed:
		# If the timer is 0 only, fill up the timer
		if mouse_current_doubleclick_time[position] == 0: mouse_current_doubleclick_time[position] = mouse_doubleclick_limit_time[position]
		
		# If we have time and we haven't reached the max amount of presses yet, add one to the counter
		if mouse_current_doubleclick_time[position] != 0 and mouse_current_doubleclick_amount[position] != mouse_doubleclick_limit_amount[position]: mouse_current_doubleclick_amount[position] += 1
	
		# If we have reached the max amount of presses, while having enough time: true it
		if mouse_current_doubleclick_time[position] != 0 and mouse_current_doubleclick_amount[position] == mouse_doubleclick_limit_amount[position]:
			return mouse_doubleclick_apply(position, true)
	
	# Calculating and clamping current doubleclick time
	if mouse_current_doubleclick_time[position] > 0: mouse_current_doubleclick_time[position] -= delta
	mouse_current_doubleclick_time[position] = clamp(mouse_current_doubleclick_time[position], 0, mouse_doubleclick_limit_time[position])
	
	# If there was no Doubleclick detected and the time is out, false it
	if mouse_current_doubleclick_time[position] == 0: return mouse_doubleclick_apply(position, false)
