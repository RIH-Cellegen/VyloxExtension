extends VScript
class_name VInput

#------------------------------------------------------------------------------------------------#

enum Device {
	None,
	Mouse,
	Keyboard,
	Joystick
}

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
	NONE,
	SPECIAL,
	ESCAPE,
	TAB,
	BACKTAB,
	BACKSPACE,
	ENTER,
	KP_ENTER,
	INSERT,
	DELETE,
	PAUSE,
	PRINT,
	SYSREQ,
	CLEAR,
	HOME,
	END,
	LEFT,
	UP,
	RIGHT,
	DOWN,
	PAGEUP,
	PAGEDOWN,
	SHIFT,
	CTRL,
	META,
	ALT,
	CAPSLOCK,
	NUMLOCK,
	SCROLLLOCK,
	F1,
	F2,
	F3,
	F4,
	F5,
	F6,
	F7,
	F8,
	F9,
	F10,
	F11,
	F12,
	F13,
	F14,
	F15,
	F16,
	F17,
	F18,
	F19,
	F20,
	F21,
	F22,
	F23,
	F24,
	F25,
	F26,
	F27,
	F28,
	F29,
	F30,
	F31,
	F32,
	F33,
	F34,
	F35,
	KP_MULTIPLY,
	KP_DIVIDE,
	KP_SUBTRACT,
	KP_PERIOD,
	KP_ADD,
	KP_0,
	KP_1,
	KP_2,
	KP_3,
	KP_4,
	KP_5,
	KP_6,
	KP_7,
	KP_8,
	KP_9,
	MENU,
	HYPER,
	HELP,
	BACK,
	FORWARD,
	STOP,
	REFRESH,
	VOLUMEDOWN,
	VOLUMEMUTE,
	VOLUMEUP,
	MEDIAPLAY,
	MEDIASTOP,
	MEDIAPREVIOUS,
	MEDIANEXT,
	MEDIARECORD,
	HOMEPAGE,
	FAVORITES,
	SEARCH,
	STANDBY,
	OPENURL,
	LAUNCHMAIL,
	LAUNCHMEDIA,
	LAUNCH0,
	LAUNCH1,
	LAUNCH2,
	LAUNCH3,
	LAUNCH4,
	LAUNCH5,
	LAUNCH6,
	LAUNCH7,
	LAUNCH8,
	LAUNCH9,
	LAUNCHA,
	LAUNCHB,
	LAUNCHC,
	LAUNCHD,
	LAUNCHE,
	LAUNCHF,
	UNKNOWN,
	SPACE,
	EXCLAM,
	QUOTEDBL,
	NUMBERSIGN,
	DOLLAR,
	PERCENT,
	AMPERSAND,
	APOSTROPHE,
	PARENLEFT,
	PARENRIGHT,
	ASTERISK,
	PLUS,
	COMMA,
	MINUS,
	PERIOD,
	SLASH,
	NUMBER_0,
	NUMBER_1,
	NUMBER_2,
	NUMBER_3,
	NUMBER_4,
	NUMBER_5,
	NUMBER_6,
	NUMBER_7,
	NUMBER_8,
	NUMBER_9,
	COLON,
	SEMICOLON,
	LESS,
	EQUAL,
	GREATER,
	QUESTION,
	AT,
	A,
	B,
	C,
	D,
	E,
	F,
	G,
	H,
	I,
	J,
	K,
	L,
	M,
	N,
	O,
	P,
	Q,
	R,
	S,
	T,
	U,
	V,
	W,
	X,
	Y,
	Z,
	BRACKETLEFT,
	BACKSLASH,
	BRACKETRIGHT,
	ASCIICIRCUM,
	UNDERSCORE,
	QUOTELEFT,
	BRACELEFT,
	BAR,
	BRACERIGHT,
	ASCIITILDE,
	YEN,
	SECTION,
	GLOBE,
	KEYBOARD,
	JIS_EISU,
	JIS_KANA
}

enum enum_action {JustPressed, Pressed, JustHeld, Held, JustReleased, Released, Doubleclicked}

#------------------------------------------------------------------------------------------------#
var mouse_current_doubleclick_time: PackedFloat64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_current_doubleclick_amount: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_doubleclick_limit_time: PackedFloat64Array =   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_doubleclick_limit_amount: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var mouse_delay: PackedFloat64Array = 			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_current_delay: PackedFloat64Array = 	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_action: PackedInt64Array = 			[5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
var mouse_doubleclicked: Array =		[false, false, false, false, false, false, false, false, false, false]
var mouse_pressed: Array = 			[false, false, false, false, false, false, false, false, false, false]
var mouse_position: int = 0

func mouse_button_just_pressed(button: Mouse_button):
	return true if mouse_action[button] == enum_action.JustPressed else false
func mouse_button_pressed(button: Mouse_button):
	return true if mouse_action[button] == enum_action.Pressed else false
func mouse_button_just_held(button: Mouse_button):
	return true if mouse_action[button] == enum_action.JustHeld else false
func mouse_button_held(button: Mouse_button):
	return true if mouse_action[button] == enum_action.Held else false
func mouse_button_just_released(button: Mouse_button):
	return true if mouse_action[button] == enum_action.JustReleased else false
func mouse_button_released(button: Mouse_button):
	return true if mouse_action[button] == enum_action.Released else false
func mouse_button_doubleclicked(button: Mouse_button):
	return mouse_doubleclicked[button]

func set_mouse_delay(button: Mouse_button, delay: float):
	mouse_delay[button] = delay
func get_mouse_delay(button: Mouse_button):
	return mouse_delay[button]

func set_doubleclick(current_mouse_button: Mouse_button, amount: float, time_frame: float):
	mouse_doubleclick_limit_amount[current_mouse_button] = amount
	mouse_doubleclick_limit_time[current_mouse_button] = time_frame
func get_doubleclick(current_mouse_button: Mouse_button) -> Array:
	var calc: Array = [
		mouse_doubleclick_limit_amount[current_mouse_button], 
		mouse_doubleclick_limit_time[current_mouse_button], 
		mouse_doubleclicked[current_mouse_button], 
		mouse_current_doubleclick_amount[current_mouse_button], 
		mouse_current_doubleclick_time[current_mouse_button]]
	return calc

#------------------------------------------------------------------------------------------------#

var keyboard_action: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var keyboard_pressed: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var keyboard_text_position: String:
	set(value):
		keyboard_text_position = value
		if keyboard_text_position != "":
			keyboard_text_position = keyboard_text_position.to_upper()
			keyboard_position = Keyboard_button.get(keyboard_text_position)
		if keyboard_text_position == "": keyboard_position = 0
var keyboard_position: int = 0

#------------------------------------------------------------------------------------------------#

var device_active: Array = [false, false, false, false]

#------------------------------------------------------------------------------------------------#

func calculate_mouse(delta):
	calc_mouse(mouse_pressed[mouse_position], delta)

func calculate_keyboard():
	pass

func calculate_joystick():
	pass

#------------------------------------------------------------------------------------------------#

func calc_mouse(mouse_pressed: bool, delta):
	calc_mouse_doubleclick(delta)
	
	if mouse_pressed:
		if mouse_action[mouse_position] == enum_action.JustReleased or mouse_action[mouse_position] == enum_action.Released:
			mouse_current_delay[mouse_position] = mouse_delay[mouse_position]
			
			if mouse_current_doubleclick_time[mouse_position] == 0:
				mouse_current_doubleclick_time[mouse_position] = mouse_doubleclick_limit_time[mouse_position]
			
			mouse_action[mouse_position] = enum_action.JustPressed
			return mouse_button_just_pressed(mouse_position)
		
		if mouse_action[mouse_position] == enum_action.JustPressed:
			mouse_action[mouse_position] = enum_action.Pressed
			return mouse_button_pressed(mouse_position)
		
		if mouse_current_delay[mouse_position] > 0:
			mouse_current_delay[mouse_position] -= delta
			mouse_current_delay[mouse_position] = clamp(mouse_current_delay[mouse_position], 0, mouse_delay[mouse_position])
			return
		
		if mouse_current_delay[mouse_position] == 0:
			if mouse_action[mouse_position] != enum_action.JustHeld and mouse_action[mouse_position] != enum_action.Held:
				mouse_action[mouse_position] = enum_action.JustHeld
				return mouse_button_just_held(mouse_position)
			
		mouse_action[mouse_position] = enum_action.Held
		return mouse_button_held(mouse_position)
	elif !mouse_pressed:
		if mouse_current_delay[mouse_position] != 0: mouse_current_delay[mouse_position] = 0
		
		if mouse_action[mouse_position] != enum_action.JustReleased and mouse_action[mouse_position] != enum_action.Released:
			mouse_action[mouse_position] = enum_action.JustReleased
			return mouse_button_just_released(mouse_position)
		
		mouse_action[mouse_position] = enum_action.Released
		return mouse_button_released(mouse_position)

func calc_mouse_doubleclick(delta):
	if mouse_current_doubleclick_time[mouse_position] > 0:
		mouse_current_doubleclick_time[mouse_position] -= delta
		mouse_current_doubleclick_time[mouse_position] = clamp(mouse_current_doubleclick_time[mouse_position], 0, mouse_doubleclick_limit_time[mouse_position])
		
		if mouse_current_doubleclick_amount[mouse_position] < mouse_doubleclick_limit_amount[mouse_position] and mouse_button_just_pressed(mouse_position):
			mouse_current_doubleclick_amount[mouse_position] += 1
		
		if mouse_current_doubleclick_amount[mouse_position] == mouse_doubleclick_limit_amount[mouse_position]:
			mouse_current_doubleclick_time[mouse_position] = 0
			mouse_current_doubleclick_amount[mouse_position] = 0
			mouse_doubleclicked[mouse_position] = true
			return mouse_button_doubleclicked(mouse_position)
	
	if mouse_current_doubleclick_time[mouse_position] == 0:
		mouse_current_doubleclick_time[mouse_position] = 0
		mouse_current_doubleclick_amount[mouse_position] = 0
		mouse_doubleclicked[mouse_position] = false

#------------------------------------------------------------------------------------------------#

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			mouse_position = event.button_index
			device_active[Device.Mouse] = true
			mouse_pressed[mouse_position] = true
		if !event.is_pressed():
			mouse_position = event.button_index
			device_active[Device.Mouse] = false
			mouse_pressed[mouse_position] = false
	if event is InputEventKey:
		if event.is_pressed() and !event.is_echo():
			keyboard_text_position = event.as_text_keycode()
			device_active[Device.Keyboard] = true
			keyboard_pressed[keyboard_position] = true
		if !event.is_pressed() and !event.is_echo():
			keyboard_text_position = event.as_text_keycode()
			device_active[Device.Keyboard] = false
			keyboard_pressed[keyboard_position] = false
