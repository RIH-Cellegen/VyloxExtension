extends VScript
class_name VInput

#------------------------------------------------------------------------------------------------#

enum Device {
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

enum Joytick_button {
	NONE,
	A,
	B,
	X,
	Y,
	LB,
	RB,
	BACK,
	START,
	GUIDE,
	L_AXIS_BUTTON,
	R_AXIS_BUTTON,
	DPAD_UP,
	DPAD_DOWN,
	DPAD_LEFT,
	DPAD_RIGHT,
	LT,
	RT,
	L_AXIS_FULL_UP,
	L_AXIS_FULL_DOWN,
	L_AXIS_FULL_LEFT,
	L_AXIS_FULL_RIGHT,
	R_AXIS_FULL_UP,
	R_AXIS_FULL_DOWN,
	R_AXIS_FULL_LEFT,
	R_AXIS_FULL_RIGHT
}


enum enum_action {JustPressed, Pressed, JustHeld, Held, JustReleased, Released}
#------------------------------------------------------------------------------------------------#

var mouse_current_velocity: Vector2 = Vector2.ZERO
var mouse_current_position: Vector2 = Vector2.ZERO

var mouse_current_doubleclick_time: PackedFloat64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_current_doubleclick_amount: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_doubleclick_limit_time: PackedFloat64Array =   [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_doubleclick_limit_amount: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var mouse_delay: PackedFloat64Array = 			[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_current_delay: PackedFloat64Array = 	[0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var mouse_action: PackedInt64Array = 			[5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
var mouse_doubleclicked: Array =		[false, false, false, false, false, false, false, false, false, false]
var mouse_pressed: Array = 			[false, false, false, false, false, false, false, false, false, false]
var mouse_index: int = 0

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
func set_mouse_delay_globally(delay: float):
	for value in mouse_delay.size():
		mouse_delay[value] = delay
func get_mouse_delay(button: Mouse_button):
	return mouse_delay[button]

func set_mouse_doubleclick(current_mouse_button: Mouse_button, amount: float, time_frame: float):
	mouse_doubleclick_limit_amount[current_mouse_button] = amount
	mouse_doubleclick_limit_time[current_mouse_button] = time_frame
func set_mouse_doubleclick_globally(amount: float, time_frame: float):
	for value in mouse_doubleclick_limit_amount.size():
		mouse_doubleclick_limit_amount[value] = amount
		mouse_doubleclick_limit_time[value] = time_frame
func get_mouse_doubleclick(current_mouse_button: Mouse_button) -> Array:
	var calc: Array = [
		mouse_doubleclick_limit_amount[current_mouse_button], 
		mouse_doubleclick_limit_time[current_mouse_button], 
		mouse_doubleclicked[current_mouse_button], 
		mouse_current_doubleclick_amount[current_mouse_button], 
		mouse_current_doubleclick_time[current_mouse_button]]
	return calc

func get_mouse_position():
	return mouse_current_position
func get_mouse_velocity():
	return mouse_current_velocity

#------------------------------------------------------------------------------------------------#

var keyboard_current_doubleclick_time: PackedFloat64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var keyboard_current_doubleclick_amount: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var keyboard_doubleclick_limit_time: PackedFloat64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var keyboard_doubleclick_limit_amount: PackedInt64Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

var keyboard_action: PackedInt64Array = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
var keyboard_doubleclicked: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var keyboard_pressed: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var keyboard_text_position: String:
	set(value):
		keyboard_text_position = value
		if keyboard_text_position != "":
			keyboard_text_position = keyboard_text_position.to_upper()
			keyboard_index = Keyboard_button.get(keyboard_text_position)
		if keyboard_text_position == "": keyboard_index = 0
var keyboard_index: int = 0

func keyboard_button_just_pressed(button: Keyboard_button):
	return true if keyboard_action[button] == enum_action.JustPressed else false
func keyboard_button_pressed(button: Keyboard_button):
	return true if keyboard_action[button] == enum_action.Pressed else false
func keyboard_button_just_released(button: Keyboard_button):
	return true if keyboard_action[button] == enum_action.JustReleased else false
func keyboard_button_released(button: Keyboard_button):
	return true if keyboard_action[button] == enum_action.Released else false
func keyboard_button_doubleclicked(button: Keyboard_button):
	return keyboard_doubleclicked[button]

func set_keyboard_doubleclick(current_keyboard_button: Keyboard_button, amount: float, time_frame: float):
	keyboard_doubleclick_limit_amount[current_keyboard_button] = amount
	keyboard_doubleclick_limit_time[current_keyboard_button] = time_frame
func set_keyboard_doubleclick_globally(amount:float, time_frame: float):
	# You can use either the limit size or the limit amount for this for loop.
	# All it matters is that we get the position of them and replace it with the parameter values.
	for value in keyboard_doubleclick_limit_time.size():
		keyboard_doubleclick_limit_time[value] = time_frame
		keyboard_doubleclick_limit_amount[value] = amount
func get_keyboard_doubleclick(current_keyboard_button: Mouse_button) -> Array:
	var calc: Array = [
		keyboard_doubleclick_limit_amount[current_keyboard_button], 
		keyboard_doubleclick_limit_time[current_keyboard_button], 
		keyboard_doubleclicked[current_keyboard_button], 
		keyboard_current_doubleclick_amount[current_keyboard_button], 
		keyboard_current_doubleclick_time[current_keyboard_button]]
	return calc

#------------------------------------------------------------------------------------------------#
var joystick_current_velocity: Array = [Vector2.ZERO, Vector2.ZERO]
var joystick_current_position: Array = [Vector2.ZERO, Vector2.ZERO]

var joystick_action: PackedInt64Array = [5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5]
var joystick_pressed: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var joystick_axis_value: Array = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]

# Records the last index position of the Joystick buttons. If it's 0, that means it occupies an empty space
# In arrays, thus no calculations will perform on any position yet.
var joystick_index: int = 0

#------------------------------------------------------------------------------------------------#

var device_active: Array = [false, false, false]
var input_active: bool = false

#------------------------------------------------------------------------------------------------#

func calculate_joystick(delta):
	pass

#------------------------------------------------------------------------------------------------#

func calc_mouse(delta):
	# Condition variables for less searching
	var action = mouse_action[mouse_index]
	var doubleclick_time = mouse_current_doubleclick_time[mouse_index]
	var doubleclick_amount = mouse_current_doubleclick_amount[mouse_index]
	var delay = mouse_current_delay[mouse_index]
	var pressed = mouse_pressed[mouse_index]
	
	calc_mouse_doubleclick(delta, doubleclick_time, doubleclick_amount)
	
	if pressed:
		if action == enum_action.JustReleased or action == enum_action.Released:
			mouse_current_delay[mouse_index] = mouse_delay[mouse_index]
			
			if doubleclick_time == 0:
				mouse_current_doubleclick_time[mouse_index] = mouse_doubleclick_limit_time[mouse_index]
			
			mouse_action[mouse_index] = enum_action.JustPressed
			return mouse_button_just_pressed(mouse_index)
		
		if action == enum_action.JustPressed:
			mouse_action[mouse_index] = enum_action.Pressed
			return mouse_button_pressed(mouse_index)
		
		if delay > 0:
			mouse_current_delay[mouse_index] -= delta
			mouse_current_delay[mouse_index] = clamp(mouse_current_delay[mouse_index], 0, mouse_delay[mouse_index])
			return
		
		if delay == 0:
			if action != enum_action.JustHeld and action != enum_action.Held:
				mouse_action[mouse_index] = enum_action.JustHeld
				return mouse_button_just_held(mouse_index)
			
		mouse_action[mouse_index] = enum_action.Held
		return mouse_button_held(mouse_index)
	elif !pressed:
		if delay != 0: mouse_current_delay[mouse_index] = 0
		
		if action != enum_action.JustReleased and action != enum_action.Released:
			mouse_action[mouse_index] = enum_action.JustReleased
			return mouse_button_just_released(mouse_index)
		
		mouse_action[mouse_index] = enum_action.Released
		return mouse_button_released(mouse_index)

func calc_mouse_doubleclick(delta, time, amount):
	if time > 0:
		mouse_current_doubleclick_time[mouse_index] -= delta
		mouse_current_doubleclick_time[mouse_index] = clamp(mouse_current_doubleclick_time[mouse_index], 0, mouse_doubleclick_limit_time[mouse_index])
		
		if amount < mouse_doubleclick_limit_amount[mouse_index] and mouse_button_just_pressed(mouse_index):
			mouse_current_doubleclick_amount[mouse_index] += 1
		
		if amount == mouse_doubleclick_limit_amount[mouse_index]:
			mouse_current_doubleclick_time[mouse_index] = 0
			mouse_current_doubleclick_amount[mouse_index] = 0
			mouse_doubleclicked[mouse_index] = true
			return mouse_button_doubleclicked(mouse_index)
	
	if time == 0:
		mouse_current_doubleclick_time[mouse_index] = 0
		mouse_current_doubleclick_amount[mouse_index] = 0
		mouse_doubleclicked[mouse_index] = false

#------------------------------------------------------------------------------------------------#

func calc_keyboard(delta):
	# Condition variables for less searching
	var action = keyboard_action[keyboard_index]
	var doubleclick_time = keyboard_current_doubleclick_time[keyboard_index]
	var doubleclick_amount = keyboard_current_doubleclick_amount[keyboard_index]
	var pressed = keyboard_pressed[keyboard_index]
	
	calc_keyboard_doubleclick(delta, doubleclick_time, doubleclick_amount)
	
	if pressed:
		if action == enum_action.JustReleased or action == enum_action.Released:
			if doubleclick_time == 0:
				keyboard_current_doubleclick_time[keyboard_index] = keyboard_doubleclick_limit_time[keyboard_index]
			
			keyboard_action[keyboard_index] = enum_action.JustPressed
			return keyboard_button_just_pressed(keyboard_index)
		
		keyboard_action[keyboard_index] = enum_action.Pressed
		return keyboard_button_pressed(keyboard_index)
	
	elif !pressed:
		if action != enum_action.JustReleased and action != enum_action.Released:
			keyboard_action[keyboard_index] = enum_action.JustReleased
			return keyboard_button_just_released(keyboard_index)
		
		keyboard_action[keyboard_index] = enum_action.Released
		return keyboard_button_released(keyboard_index)

func calc_keyboard_doubleclick(delta, time, amount):
	if time > 0:
		keyboard_current_doubleclick_time[keyboard_index] -= delta
		keyboard_current_doubleclick_time[keyboard_index] = clamp(keyboard_current_doubleclick_time[keyboard_index], 0, keyboard_doubleclick_limit_time[keyboard_index])
		
		if amount < keyboard_doubleclick_limit_amount[keyboard_index] and keyboard_button_just_pressed(keyboard_index):
			keyboard_current_doubleclick_amount[keyboard_index] += 1
		
		if amount == keyboard_doubleclick_limit_amount[keyboard_index]:
			keyboard_current_doubleclick_time[keyboard_index] = 0
			keyboard_current_doubleclick_amount[keyboard_index] = 0
			keyboard_doubleclicked[keyboard_index] = true
			
			return keyboard_button_doubleclicked(keyboard_index)
	
	if time == 0:
		keyboard_current_doubleclick_time[keyboard_index] = 0
		keyboard_current_doubleclick_amount[keyboard_index] = 0
		keyboard_doubleclicked[keyboard_index] = false

#------------------------------------------------------------------------------------------------#

func _ready():
	mouse_current_position = Vector2(get_window().get_mouse_position().x, get_window().get_mouse_position().x)
	mouse_current_velocity = Input.get_last_mouse_velocity()

func _process(delta):
	if mouse_current_velocity == Input.get_last_mouse_velocity() and mouse_current_position == Vector2(get_window().get_mouse_position().x, get_window().get_mouse_position().y) and mouse_pressed[mouse_index] == false:
		if device_active[Device.Mouse] != false: device_active[Device.Mouse] = false
	if mouse_current_velocity != Input.get_last_mouse_velocity():
		mouse_current_velocity = Input.get_last_mouse_velocity()
	
	if mouse_current_position != Vector2(get_window().get_mouse_position().x, get_window().get_mouse_position().y):
		if device_active[Device.Mouse] != true: device_active[Device.Mouse] = true
		mouse_current_position = Vector2(get_window().get_mouse_position().x, get_window().get_mouse_position().y)
	
	# if the Mouse has been detected regardless of other device inputs
	if device_active[Device.Mouse] == true: calc_mouse(delta)
	# if the Keyboard has been detected regardless of other device inputs
	if device_active[Device.Keyboard] == true: calc_keyboard(delta)
	# if Mouse or Keyboard input has been detected, then it automatically disables
	# Joystick device input. Keyboard and Mouse inputs have greater priority over Joystick inputs.
	if device_active[Device.Mouse] == true or device_active[Device.Keyboard] == true:
		if device_active[Device.Joystick] != false: device_active[Device.Joystick] = false
		# return the function, so in case the Joystick input is true, it wouldn't fight over
		# Priority. If you switch these two conditions and put the "return" in the first one,
		# that function will have priority. // TODO: Make a function, which does it automatically.
		return
	# If Joystick input has been detected and the previous conditions didn't return (this one
	# has lower priority after all)
	if device_active[Device.Joystick] == true:
		device_active[Device.Mouse] = false
		device_active[Device.Keyboard] = false
		#calc_joystick(delta)
	

func _input(event):
	if input_active != true: input_active = true
	
	if event is InputEventKey:
		if event.is_pressed() and !event.is_echo():
			keyboard_text_position = event.as_text_keycode()
			device_active[Device.Keyboard] = true
			keyboard_pressed[keyboard_index] = true
		if !event.is_pressed() and !event.is_echo():
			keyboard_text_position = event.as_text_keycode()
			device_active[Device.Keyboard] = false
			keyboard_pressed[keyboard_index] = false
	elif event is InputEventJoypadButton:
		if event.is_pressed():
			joystick_index = event.button_index + 1
			joystick_pressed[event.button_index + 1] = true
			device_active[Device.Joystick] = true
		if !event.is_pressed():
			joystick_index = event.button_index + 1
			joystick_pressed[event.button_index + 1] = false
			device_active[Device.Joystick] = false
	elif event is InputEventJoypadMotion:
		if device_active[Device.Joystick] != true: device_active[Device.Joystick] = true
	elif event is InputEventMouseButton:
		if event.is_pressed():
			mouse_index = event.button_index
			device_active[Device.Mouse] = true
			mouse_pressed[mouse_index] = true
		if !event.is_pressed():
			mouse_index = event.button_index
			mouse_pressed[mouse_index] = false
			if mouse_current_velocity == Vector2.ZERO: device_active[Device.Mouse] = false
