extends "res://addons/Vylox Extension/Core/VScript/VScript.gd"

enum Device {Mouse, Keyboard, Joystick}
enum Mouse_button {LEFT, RIGHT, MIDDLE, WHEEL_UP, WHEEL_DOWN, WHEEL_LEFT, WHEEL_RIGHT, XBUTTON1, XBUTTON2}
enum Keyboard_button {NONE, SPECIAL, ESCAPE, TAB, BACKTAB, BACKSPACE, ENTER, KP_ENTER, INSERT, DELETE, PAUSE,PRINT, SYSREQ, CLEAR, HOME, END, LEFT, UP, RIGHT, DOWN, PAGEUP, PAGEDOWN, SHIFT, CTRL, META, ALT, CAPSLOCK, NUMLOCK,SCROLLLOCK, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20, F21,F22, F23, F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,KP_MULTIPLY,KP_DIVIDE,KP_SUBTRACT,KP_PERIOD,KP_ADD,KP_0,KP_1,KP_2,KP_3,KP_4,KP_5,KP_6,KP_7,KP_8,KP_9,MENU,HYPER,HELP,BACK,FORWARD,STOP,REFRESH,VOLUMEDOWN,VOLUMEMUTE,VOLUMEUP,MEDIAPLAY,MEDIASTOP,MEDIAPREVIOUS,MEDIANEXT,MEDIARECORD,HOMEPAGE,FAVORITES,SEARCH,STANDBY,OPENURL,LAUNCHMAIL,LAUNCHMEDIA,LAUNCH0,LAUNCH1,LAUNCH2,LAUNCH3,LAUNCH4,LAUNCH5,LAUNCH6,LAUNCH7,LAUNCH8,LAUNCH9,LAUNCHA,LAUNCHB,LAUNCHC,LAUNCHD,LAUNCHE,LAUNCHF,UNKNOWN,SPACE,EXCLAM,QUOTEDBL,NUMBERSIGN,DOLLAR,PERCENT,AMPERSAND,APOSTROPHE,PARENLEFT,PARENRIGHT,ASTERISK,PLUS,COMMA,MINUS,PERIOD,SLASH,NUMBER_0,NUMBER_1,NUMBER_2,NUMBER_3,NUMBER_4,NUMBER_5,NUMBER_6,NUMBER_7,NUMBER_8,NUMBER_9,COLON,SEMICOLON,LESS,EQUAL,GREATER,QUESTION,AT,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,BRACKETLEFT,BACKSLASH,BRACKETRIGHT,ASCIICIRCUM,UNDERSCORE,QUOTELEFT,BRACELEFT,BAR,BRACERIGHT,ASCIITILDE,YEN,SECTION,GLOBE,KEYBOARD,JIS_EISU,JIS_KANA}
enum Joystick_button {A, B, X, Y, LB, RB, LT, RT, START, BACK, CONNECTION_BUTTON, LAXIS_BUTTON, RAXIS_BUTTON, DPAD_UP, DPAD_DOWN, DPAD_LEFT, DPAD_RIGHT, LAXIS_UP, LAXIS_DOWN, LAXIS_LEFT, LAXIS_RIGHT, RAXIS_UP, RAXIS_DOWN, RAXIS_LEFT, RAXIS_RIGHT}
enum Joystick_motion {LT, RT, LAXIS_UP, LAXIS_DOWN, LAXIS_LEFT, LAXIS_RIGHT, RAXIS_UP, RAXIS_DOWN, RAXIS_LEFT, RAXIS_RIGHT, LAXIS, RAXIS}
enum Action {JustPressed, Pressed, JustHeld, Held, JustReleased, Released}
enum KeyboardAction {JustPressed, Pressed, JustReleased, Released}
enum DoubleclickAction {False, Ongoing, Failed, True}
enum Joystick_motion_radius {TopRight, BottomRight, ButtomLeft, TopLeft}

var mouse_pressed: Array = []
var keyboard_pressed: Array = []
var joystick_pressed: Array = []

var mouse_action: Array = []
var mouse_current_doubleclick_time: PackedFloat64Array = []
var mouse_current_doubleclick_amount: PackedInt64Array = []
var mouse_current_delay: PackedFloat64Array = []
var mouse_doubleclick_action: PackedInt64Array = []
var mouse_limit_doubleclick_time: PackedFloat64Array = []
var mouse_limit_doubleclick_amount: PackedInt64Array = []
var mouse_limit_delay: PackedFloat64Array = []

var keyboard_action: Array = []
var keyboard_current_doubleclick_time: PackedFloat64Array = []
var keyboard_current_doubleclick_amount: PackedInt64Array = []
var keyboard_doubleclick_action: PackedInt64Array = []
var keyboard_limit_doubleclick_time: PackedFloat64Array = []
var keyboard_limit_doubleclick_amount: PackedInt64Array = []

var joystick_action: Array = []
var joystick_current_doubleclick_time: PackedFloat64Array = []
var joystick_current_doubleclick_amount: PackedInt64Array = []
var joystick_current_delay: PackedFloat64Array = []
var joystick_doubleclick_action: PackedInt64Array = []
var joystick_limit_doubleclick_time: PackedFloat64Array = []
var joystick_limit_doubleclick_amount: PackedInt64Array = []
var joystick_limit_delay: PackedFloat64Array = []
var joystick_motion: Array = []
var joystick_laxis_radius_topright: float = 0.25
var joystick_laxis_radius_bottomright: float = 0.25
var joystick_laxis_radius_bottomleft: float = 0.25
var joystick_laxis_radius_topleft: float = 0.25
var joystick_raxis_radius_topright: float = 0.25
var joystick_raxis_radius_bottomright: float = 0.25
var joystick_raxis_radius_bottomleft: float = 0.25
var joystick_raxis_radius_topleft: float = 0.25

var current_configuration: Array = []
var previous_configuration: Array = []
var default_configuration: Array = []
var reset_values: bool

var current_device: int:
	set(value):
		current_device = value
		if reset_values:
			match current_device:
				Device.Mouse: set_joystick_values()
				Device.Keyboard: set_joystick_values()
				Device.Joystick:
					set_mouse_values()
					set_keyboard_values()

func apply_mouse_pressed(delta):
	var array = [Input.is_action_pressed("mouse_left"),Input.is_action_pressed("mouse_right"),Input.is_action_pressed("mouse_middle"),Input.is_action_pressed("mouse_wheel_up"),Input.is_action_pressed("mouse_wheel_down"),Input.is_action_pressed("mouse_wheel_left"),Input.is_action_pressed("mouse_wheel_right"),Input.is_action_pressed("mouse_xbutton_1"),Input.is_action_pressed("mouse_xbutton_2")]
	if mouse_pressed != array:
		mouse_pressed = array
	for position in mouse_pressed.size():
		calculate_mouse(delta, position)
func apply_joystick_pressed(delta):
	var array = [Input.is_action_pressed("joystick_a"),Input.is_action_pressed("joystick_b"),Input.is_action_pressed("joystick_x"),Input.is_action_pressed("joystick_y"),Input.is_action_pressed("joystick_lb"),Input.is_action_pressed("joystick_rb"),Input.is_action_pressed("joystick_lt"),Input.is_action_pressed("joystick_rt"),Input.is_action_pressed("joystick_start"),Input.is_action_pressed("joystick_back"),Input.is_action_pressed("joystick_connection_button"),Input.is_action_pressed("joystick_laxis_button"),Input.is_action_pressed("joystick_raxis_button"),Input.is_action_pressed("joystick_dpad_up"),Input.is_action_pressed("joystick_dpad_down"),Input.is_action_pressed("joystick_dpad_left"),Input.is_action_pressed("joystick_dpad_right"),Input.is_action_pressed("joystick_laxis_up"),Input.is_action_pressed("joystick_laxis_down"),Input.is_action_pressed("joystick_laxis_left"),Input.is_action_pressed("joystick_laxis_right"),Input.is_action_pressed("joystick_raxis_up"),Input.is_action_pressed("joystick_raxis_down"),Input.is_action_pressed("joystick_raxis_left"),Input.is_action_pressed("joystick_raxis_right")]
	if joystick_pressed != array:
		joystick_pressed = array
	var array_motion: Array = [Input.get_action_raw_strength("joystick_lt"), Input.get_action_raw_strength("joystick_rt"), Input.get_action_raw_strength("joystick_laxis_up"), Input.get_action_raw_strength("joystick_laxis_down"), Input.get_action_raw_strength("joystick_laxis_left"), Input.get_action_raw_strength("joystick_laxis_right"), Input.get_action_raw_strength("joystick_raxis_up"), Input.get_action_raw_strength("joystick_raxis_down"), Input.get_action_raw_strength("joystick_raxis_left"), Input.get_action_raw_strength("joystick_raxis_right"), Vector2(Input.get_action_raw_strength("joystick_laxis_right") - Input.get_action_raw_strength("joystick_laxis_left"), Input.get_action_raw_strength("joystick_laxis_up") - Input.get_action_raw_strength("joystick_laxis_down")), Vector2(Input.get_action_raw_strength("joystick_raxis_right") - Input.get_action_raw_strength("joystick_raxis_left"), Input.get_action_raw_strength("joystick_raxis_up") - Input.get_action_raw_strength("joystick_raxis_down"))]
	if joystick_motion != array_motion:
		joystick_motion = array_motion
		if joystick_motion[Joystick_motion.LAXIS].x < 0.001 and joystick_motion[Joystick_motion.LAXIS].x > -0.001:
			joystick_motion[Joystick_motion.LAXIS].x = 0
		if joystick_motion[Joystick_motion.LAXIS].y < 0.001 and joystick_motion[Joystick_motion.LAXIS].y > -0.001:
			joystick_motion[Joystick_motion.LAXIS].y = 0
		if joystick_motion[Joystick_motion.RAXIS].x < 0.001 and joystick_motion[Joystick_motion.RAXIS].x > -0.001:
			joystick_motion[Joystick_motion.RAXIS].x = 0
		if joystick_motion[Joystick_motion.RAXIS].y < 0.001 and joystick_motion[Joystick_motion.RAXIS].y > -0.001:
			joystick_motion[Joystick_motion.RAXIS].y = 0
	
	for position in joystick_pressed.size():
		calculate_joystick(delta, position)
func apply_keyboard_pressed(delta):
	var array = [Input.is_key_pressed(KEY_NONE),Input.is_key_pressed(KEY_SPECIAL),Input.is_key_pressed(KEY_ESCAPE),Input.is_key_pressed(KEY_TAB),Input.is_key_pressed(KEY_BACKTAB),Input.is_key_pressed(KEY_BACKSPACE),Input.is_key_pressed(KEY_ENTER),Input.is_key_pressed(KEY_KP_ENTER),Input.is_key_pressed(KEY_INSERT),Input.is_key_pressed(KEY_DELETE),Input.is_key_pressed(KEY_PAUSE),Input.is_key_pressed(KEY_PRINT),Input.is_key_pressed(KEY_SYSREQ),Input.is_key_pressed(KEY_CLEAR),Input.is_key_pressed(KEY_HOME),Input.is_key_pressed(KEY_END),Input.is_key_pressed(KEY_LEFT),Input.is_key_pressed(KEY_UP),Input.is_key_pressed(KEY_RIGHT),Input.is_key_pressed(KEY_DOWN),Input.is_key_pressed(KEY_PAGEUP),Input.is_key_pressed(KEY_PAGEDOWN),Input.is_key_pressed(KEY_SHIFT),Input.is_key_pressed(KEY_CTRL),Input.is_key_pressed(KEY_META),Input.is_key_pressed(KEY_ALT),Input.is_key_pressed(KEY_CAPSLOCK),Input.is_key_pressed(KEY_NUMLOCK),Input.is_key_pressed(KEY_SCROLLLOCK),Input.is_key_pressed(KEY_F1),Input.is_key_pressed(KEY_F2),Input.is_key_pressed(KEY_F3),Input.is_key_pressed(KEY_F4),Input.is_key_pressed(KEY_F5),Input.is_key_pressed(KEY_F6),Input.is_key_pressed(KEY_F7),Input.is_key_pressed(KEY_F8),Input.is_key_pressed(KEY_F9),Input.is_key_pressed(KEY_F10),Input.is_key_pressed(KEY_F11),Input.is_key_pressed(KEY_F12),Input.is_key_pressed(KEY_F13),Input.is_key_pressed(KEY_F14),Input.is_key_pressed(KEY_F15),Input.is_key_pressed(KEY_F16),Input.is_key_pressed(KEY_F17),Input.is_key_pressed(KEY_F18),Input.is_key_pressed(KEY_F19),Input.is_key_pressed(KEY_F20),Input.is_key_pressed(KEY_F21),Input.is_key_pressed(KEY_F22),Input.is_key_pressed(KEY_F23),Input.is_key_pressed(KEY_F24),Input.is_key_pressed(KEY_F25),Input.is_key_pressed(KEY_F26),Input.is_key_pressed(KEY_F27),Input.is_key_pressed(KEY_F28),Input.is_key_pressed(KEY_F29),Input.is_key_pressed(KEY_F30),Input.is_key_pressed(KEY_F31),Input.is_key_pressed(KEY_F32),Input.is_key_pressed(KEY_F33),Input.is_key_pressed(KEY_F34),Input.is_key_pressed(KEY_F35),Input.is_key_pressed(KEY_KP_MULTIPLY),Input.is_key_pressed(KEY_KP_DIVIDE),Input.is_key_pressed(KEY_KP_SUBTRACT),Input.is_key_pressed(KEY_KP_PERIOD),Input.is_key_pressed(KEY_KP_ADD),Input.is_key_pressed(KEY_KP_0),Input.is_key_pressed(KEY_KP_1),Input.is_key_pressed(KEY_KP_2),Input.is_key_pressed(KEY_KP_3),Input.is_key_pressed(KEY_KP_4),Input.is_key_pressed(KEY_KP_5),Input.is_key_pressed(KEY_KP_6),Input.is_key_pressed(KEY_KP_7),Input.is_key_pressed(KEY_KP_8),Input.is_key_pressed(KEY_KP_9),Input.is_key_pressed(KEY_MENU),Input.is_key_pressed(KEY_HYPER),Input.is_key_pressed(KEY_HELP),Input.is_key_pressed(KEY_BACK),Input.is_key_pressed(KEY_FORWARD),Input.is_key_pressed(KEY_STOP),Input.is_key_pressed(KEY_REFRESH),Input.is_key_pressed(KEY_VOLUMEDOWN),Input.is_key_pressed(KEY_VOLUMEMUTE),Input.is_key_pressed(KEY_VOLUMEUP),Input.is_key_pressed(KEY_MEDIAPLAY),Input.is_key_pressed(KEY_MEDIASTOP),Input.is_key_pressed(KEY_MEDIAPREVIOUS),Input.is_key_pressed(KEY_MEDIANEXT),Input.is_key_pressed(KEY_MEDIARECORD),Input.is_key_pressed(KEY_HOMEPAGE),Input.is_key_pressed(KEY_FAVORITES),Input.is_key_pressed(KEY_SEARCH),Input.is_key_pressed(KEY_STANDBY),Input.is_key_pressed(KEY_OPENURL),Input.is_key_pressed(KEY_LAUNCHMAIL),Input.is_key_pressed(KEY_LAUNCHMEDIA),Input.is_key_pressed(KEY_LAUNCH0),Input.is_key_pressed(KEY_LAUNCH1),Input.is_key_pressed(KEY_LAUNCH2),Input.is_key_pressed(KEY_LAUNCH3),Input.is_key_pressed(KEY_LAUNCH4),Input.is_key_pressed(KEY_LAUNCH5),Input.is_key_pressed(KEY_LAUNCH6),Input.is_key_pressed(KEY_LAUNCH7),Input.is_key_pressed(KEY_LAUNCH8),Input.is_key_pressed(KEY_LAUNCH9),Input.is_key_pressed(KEY_LAUNCHA),Input.is_key_pressed(KEY_LAUNCHB),Input.is_key_pressed(KEY_LAUNCHC),Input.is_key_pressed(KEY_LAUNCHD),Input.is_key_pressed(KEY_LAUNCHE),Input.is_key_pressed(KEY_LAUNCHF),Input.is_key_pressed(KEY_UNKNOWN),Input.is_key_pressed(KEY_SPACE),Input.is_key_pressed(KEY_EXCLAM),Input.is_key_pressed(KEY_QUOTEDBL),Input.is_key_pressed(KEY_NUMBERSIGN),Input.is_key_pressed(KEY_DOLLAR),Input.is_key_pressed(KEY_PERCENT),Input.is_key_pressed(KEY_AMPERSAND),Input.is_key_pressed(KEY_APOSTROPHE),Input.is_key_pressed(KEY_PARENLEFT),Input.is_key_pressed(KEY_PARENRIGHT),Input.is_key_pressed(KEY_ASTERISK),Input.is_key_pressed(KEY_PLUS),Input.is_key_pressed(KEY_COMMA),Input.is_key_pressed(KEY_MINUS),Input.is_key_pressed(KEY_PERIOD),Input.is_key_pressed(KEY_SLASH),Input.is_key_pressed(KEY_0),Input.is_key_pressed(KEY_1),Input.is_key_pressed(KEY_2),Input.is_key_pressed(KEY_3),Input.is_key_pressed(KEY_4),Input.is_key_pressed(KEY_5),Input.is_key_pressed(KEY_6),Input.is_key_pressed(KEY_7),Input.is_key_pressed(KEY_8),Input.is_key_pressed(KEY_9),Input.is_key_pressed(KEY_COLON),Input.is_key_pressed(KEY_SEMICOLON),Input.is_key_pressed(KEY_LESS),Input.is_key_pressed(KEY_EQUAL),Input.is_key_pressed(KEY_GREATER),Input.is_key_pressed(KEY_QUESTION),Input.is_key_pressed(KEY_AT),Input.is_key_pressed(KEY_A),Input.is_key_pressed(KEY_B),Input.is_key_pressed(KEY_C),Input.is_key_pressed(KEY_D),Input.is_key_pressed(KEY_E),Input.is_key_pressed(KEY_F),Input.is_key_pressed(KEY_G),Input.is_key_pressed(KEY_H),Input.is_key_pressed(KEY_I),Input.is_key_pressed(KEY_J),Input.is_key_pressed(KEY_K),Input.is_key_pressed(KEY_L),Input.is_key_pressed(KEY_M),Input.is_key_pressed(KEY_N),Input.is_key_pressed(KEY_O),Input.is_key_pressed(KEY_P),Input.is_key_pressed(KEY_Q),Input.is_key_pressed(KEY_R),Input.is_key_pressed(KEY_S),Input.is_key_pressed(KEY_T),Input.is_key_pressed(KEY_U),Input.is_key_pressed(KEY_V),Input.is_key_pressed(KEY_W),Input.is_key_pressed(KEY_X),Input.is_key_pressed(KEY_Y),Input.is_key_pressed(KEY_Z),Input.is_key_pressed(KEY_BRACKETLEFT),Input.is_key_pressed(KEY_BACKSLASH),Input.is_key_pressed(KEY_BRACKETRIGHT),Input.is_key_pressed(KEY_ASCIICIRCUM),Input.is_key_pressed(KEY_UNDERSCORE),Input.is_key_pressed(KEY_QUOTELEFT),Input.is_key_pressed(KEY_BRACELEFT),Input.is_key_pressed(KEY_BAR),Input.is_key_pressed(KEY_BRACERIGHT),Input.is_key_pressed(KEY_ASCIITILDE),Input.is_key_pressed(KEY_YEN),Input.is_key_pressed(KEY_SECTION),Input.is_key_pressed(KEY_GLOBE),Input.is_key_pressed(KEY_KEYBOARD),Input.is_key_pressed(KEY_JIS_EISU),Input.is_key_pressed(KEY_JIS_KANA)]
	if keyboard_pressed != array:
		keyboard_pressed = array
	for position in keyboard_pressed.size():
		calculate_keyboard(delta, position)

func set_mouse_values():
	mouse_pressed.resize(Mouse_button.keys().size())
	mouse_pressed.fill(false)
	mouse_current_doubleclick_time.resize(Mouse_button.keys().size())
	mouse_current_doubleclick_time.fill(0.0)
	mouse_current_doubleclick_amount.resize(Mouse_button.keys().size())
	mouse_current_doubleclick_amount.fill(0)
	mouse_limit_doubleclick_time.resize(Mouse_button.keys().size())
	mouse_limit_doubleclick_amount.resize(Mouse_button.keys().size())
	mouse_limit_delay.resize(Mouse_button.keys().size())
	mouse_doubleclick_action.resize(Mouse_button.keys().size())
	mouse_doubleclick_action.fill(DoubleclickAction.False)
	mouse_current_delay.resize(Mouse_button.keys().size())
	mouse_current_delay.fill(0.0)
	mouse_action.resize(Mouse_button.keys().size())
	mouse_action.fill(Action.Released)
func set_keyboard_values():
	keyboard_pressed.resize(Keyboard_button.keys().size())
	keyboard_pressed.fill(false)
	keyboard_current_doubleclick_time.resize(Keyboard_button.keys().size())
	keyboard_current_doubleclick_time.fill(0.0)
	keyboard_current_doubleclick_amount.resize(Keyboard_button.keys().size())
	keyboard_current_doubleclick_amount.fill(0)
	keyboard_limit_doubleclick_time.resize(Keyboard_button.keys().size())
	keyboard_limit_doubleclick_amount.resize(Keyboard_button.keys().size())
	keyboard_doubleclick_action.resize(Keyboard_button.keys().size())
	keyboard_doubleclick_action.fill(DoubleclickAction.False)
	keyboard_action.resize(Keyboard_button.keys().size())
	keyboard_action.fill(KeyboardAction.Released)
func set_joystick_values():
	joystick_pressed.resize(Joystick_button.keys().size())
	joystick_pressed.fill(false)
	joystick_motion.resize(Joystick_motion.keys().size())
	joystick_motion.fill(0.0)
	joystick_current_doubleclick_time.resize(Joystick_button.keys().size())
	joystick_current_doubleclick_time.fill(0.0)
	joystick_current_doubleclick_amount.resize(Joystick_button.keys().size())
	joystick_current_doubleclick_amount.fill(0)
	joystick_limit_doubleclick_time.resize(Joystick_button.keys().size())
	joystick_limit_doubleclick_amount.resize(Joystick_button.keys().size())
	joystick_limit_delay.resize(Joystick_button.keys().size())
	joystick_doubleclick_action.resize(Joystick_button.keys().size())
	joystick_doubleclick_action.fill(DoubleclickAction.False)
	joystick_current_delay.resize(Joystick_button.keys().size())
	joystick_current_delay.fill(0.0)
	joystick_action.resize(Joystick_button.keys().size())
	joystick_action.fill(Action.Released)

func _ready():
	set_mouse_values()
	set_keyboard_values()
	set_joystick_values()
	
	set_mouse_delay_globally(1)
	set_mouse_doubleclick_globally(2, 2)
	
	set_keyboard_doubleclick_globally(2, 2)
	
	set_joystick_delay_globally(0.25)
	set_joystick_doubleclick_globally(1, 2)
	set_joystick_axis_radius_globally(Joystick_motion.LAXIS, 0.3)
	
	keyboard_pressed.resize(Keyboard_button.keys().size())
	keyboard_pressed.fill(false)
	joystick_pressed.resize(Joystick_button.keys().size())
	joystick_pressed.fill(false)

func mouse_button_just_pressed(button: Mouse_button):
	return true if mouse_action[button] == Action.JustPressed else false
func mouse_button_pressed(button: Mouse_button):
	return true if mouse_action[button] == Action.Pressed else false
func mouse_button_just_held(button: Mouse_button):
	return true if mouse_action[button] == Action.JustHeld else false
func mouse_button_held(button: Mouse_button):
	return true if mouse_action[button] == Action.Held else false
func mouse_button_just_released(button: Mouse_button):
	return true if mouse_action[button] == Action.JustReleased else false
func mouse_button_released(button: Mouse_button):
	return true if mouse_action[button] == Action.Released else false
func mouse_button_doubleclicked(button: Mouse_button):
	return true if mouse_doubleclick_action[button] == DoubleclickAction.True else false
func mouse_button_doubleclick_failed(button: Mouse_button):
	return true if mouse_doubleclick_action[button] == DoubleclickAction.Failed else false

func set_mouse_delay_globally(time: float):
	mouse_limit_delay.fill(time)
func set_mouse_delay(button: Mouse_button, time: float):
	mouse_limit_delay[button] = time
func set_mouse_doubleclick_globally(time: float, amount: int):
	mouse_limit_doubleclick_time.fill(time)
	mouse_limit_doubleclick_amount.fill(amount)
func set_mouse_doubleclick(button: Mouse_button, time: float, amount: int):
	mouse_limit_doubleclick_time[button] = time
	mouse_limit_doubleclick_amount[button] = amount

func get_mouse_current_delay(button: Mouse_button):
	return mouse_current_delay[button]
func get_mouse_limit_delay(button: Mouse_button):
	return mouse_limit_delay[button]
func get_all_mouse_current_delays() -> Array:
	var calc: Array = []
	calc.resize(Mouse_button.keys().size())
	for position in Mouse_button.keys().size():
		calc[position] = mouse_current_delay[position]
	return calc
func get_all_mouse_limit_delays() -> Array:
	var calc: Array = []
	calc.resize(Mouse_button.keys().size())
	for position in Mouse_button.keys().size():
		calc[position] = mouse_limit_delay[position]
	return calc
func get_mouse_current_doubleclick_time(button: Mouse_button):
	return mouse_current_doubleclick_time[button]
func get_mouse_limit_doubleclick_time(button: Mouse_button):
	return mouse_limit_doubleclick_time[button]
func get_mouse_current_doubleclick_amount(button: Mouse_button):
	return mouse_current_doubleclick_amount[button]
func get_mouse_limit_doubleclick_amount(button: Mouse_button):
	return mouse_limit_doubleclick_time[button]
func get_all_mouse_current_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Mouse_button.keys().size())
	for position in Mouse_button.keys().size():
		calc[position] = mouse_current_doubleclick_time[position]
	return calc
func get_all_mouse_current_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Mouse_button.keys().size())
	for position in Mouse_button.keys().size():
		calc[position] = mouse_current_doubleclick_amount[position]
	return calc
func get_all_mouse_limit_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Mouse_button.keys().size())
	for position in Mouse_button.keys().size():
		calc[position] = mouse_limit_doubleclick_time[position]
	return calc
func get_all_mouse_limit_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Mouse_button.keys().size())
	for position in Mouse_button.keys().size():
		calc[position] = mouse_limit_doubleclick_amount[position]
	return calc


func keyboard_button_just_pressed(button: Keyboard_button):
	return true if keyboard_action[button] == KeyboardAction.JustPressed else false
func keyboard_button_pressed(button: Keyboard_button):
	return true if keyboard_action[button] == KeyboardAction.Pressed else false
func keyboard_button_just_released(button: Keyboard_button):
	return true if keyboard_action[button] == KeyboardAction.JustReleased else false
func keyboard_button_released(button: Keyboard_button):
	return true if keyboard_action[button] == KeyboardAction.Released else false
func keyboard_button_doubleclicked(button: Keyboard_button):
	return true if keyboard_doubleclick_action[button] == DoubleclickAction.True else false
func keyboard_button_doubleclick_failed(button: Keyboard_button):
	return true if keyboard_doubleclick_action[button] == DoubleclickAction.Failed else false

func set_keyboard_doubleclick_globally(time: float, amount: int):
	keyboard_limit_doubleclick_time.fill(time)
	keyboard_limit_doubleclick_amount.fill(amount)
func set_keyboard_doubleclick(button: Keyboard_button, time: float, amount: int):
	keyboard_limit_doubleclick_time[button] = time
	keyboard_limit_doubleclick_amount[button] = amount

func get_keyboard_current_doubleclick_time(button: Keyboard_button):
	return keyboard_current_doubleclick_time[button]
func get_keyboard_limit_doubleclick_time(button: Keyboard_button):
	return keyboard_limit_doubleclick_time[button]
func get_keyboard_current_doubleclick_amount(button: Keyboard_button):
	return keyboard_current_doubleclick_amount[button]
func get_keyboard_limit_doubleclick_amount(button: Keyboard_button):
	return keyboard_limit_doubleclick_time[button]
func get_all_keyboard_current_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Keyboard_button.keys().size())
	for position in Keyboard_button.keys().size():
		calc[position] = keyboard_current_doubleclick_time[position]
	return calc
func get_all_keyboard_current_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Keyboard_button.keys().size())
	for position in Keyboard_button.keys().size():
		calc[position] = keyboard_current_doubleclick_amount[position]
	return calc
func get_all_keyboard_limit_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Keyboard_button.keys().size())
	for position in Keyboard_button.keys().size():
		calc[position] = keyboard_limit_doubleclick_time[position]
	return calc
func get_all_keyboard_limit_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Keyboard_button.keys().size())
	for position in Keyboard_button.keys().size():
		calc[position] = keyboard_limit_doubleclick_amount[position]
	return calc


func joystick_button_just_pressed(button: Joystick_button):
	return true if joystick_action[button] == Action.JustPressed else false
func joystick_button_pressed(button: Joystick_button):
	return true if joystick_action[button] == Action.Pressed else false
func joystick_button_just_held(button: Joystick_button):
	return true if joystick_action[button] == Action.JustHeld else false
func joystick_button_held(button: Joystick_button):
	return true if joystick_action[button] == Action.Held else false
func joystick_button_just_released(button: Joystick_button):
	return true if joystick_action[button] == Action.JustReleased else false
func joystick_button_released(button: Joystick_button):
	return true if joystick_action[button] == Action.Released else false
func joystick_button_doubleclicked(button: Joystick_button):
	return true if joystick_doubleclick_action[button] == DoubleclickAction.True else false
func joystick_button_doubleclick_failed(button: Joystick_button):
	return true if joystick_doubleclick_action[button] == DoubleclickAction.Failed else false
func joystick_motion_reached_topright(motion: Joystick_motion):
	if motion == Joystick_motion.LAXIS:
		return (joystick_motion_exceeded(Joystick_motion.LAXIS_RIGHT, joystick_laxis_radius_topright) and joystick_motion_exceeded(Joystick_motion.LAXIS_UP, joystick_laxis_radius_topright))
	if motion == Joystick_motion.RAXIS:
		return (joystick_motion_exceeded(Joystick_motion.RAXIS_RIGHT, joystick_laxis_radius_topright) and joystick_motion_exceeded(Joystick_motion.RAXIS_UP, joystick_laxis_radius_topright))
	push_error('Error in joystick_motion_reached_topright() function in VInput: Set Parameter cannot be used for calculations. Use either "LAXIS" or "RAXIS" Parameters.')
	return false
func joystick_motion_reached_bottomright(motion: Joystick_motion):
	if motion == Joystick_motion.LAXIS:
		return (joystick_motion_exceeded(Joystick_motion.LAXIS_RIGHT, joystick_laxis_radius_bottomright) and joystick_motion_exceeded(Joystick_motion.LAXIS_DOWN, joystick_laxis_radius_bottomright))
	if motion == Joystick_motion.RAXIS:
		return (joystick_motion_exceeded(Joystick_motion.RAXIS_RIGHT, joystick_laxis_radius_bottomright) and joystick_motion_exceeded(Joystick_motion.RAXIS_DOWN, joystick_laxis_radius_bottomright))
	push_error('Error in joystick_motion_reached_bottomright() function in VInput: Set Parameter cannot be used for calculations. Use either "LAXIS" or "RAXIS" Parameters.')
	return false
func joystick_motion_reached_bottomleft(motion: Joystick_motion):
	if motion == Joystick_motion.LAXIS:
		return (joystick_motion_exceeded(Joystick_motion.LAXIS_LEFT, joystick_laxis_radius_bottomleft) and joystick_motion_exceeded(Joystick_motion.LAXIS_DOWN, joystick_laxis_radius_bottomleft))
	if motion == Joystick_motion.RAXIS:
		return (joystick_motion_exceeded(Joystick_motion.RAXIS_LEFT, joystick_laxis_radius_bottomleft) and joystick_motion_exceeded(Joystick_motion.RAXIS_DOWN, joystick_laxis_radius_bottomleft))
	push_error('Error in joystick_motion_reached_bottomleft() function in VInput: Set Parameter cannot be used for calculations. Use either "LAXIS" or "RAXIS" Parameters.')
	return false
func joystick_motion_reached_topleft(motion: Joystick_motion):
	if motion == Joystick_motion.LAXIS:
		return (joystick_motion_exceeded(Joystick_motion.LAXIS_LEFT, joystick_laxis_radius_topleft) and joystick_motion_exceeded(Joystick_motion.LAXIS_UP, joystick_laxis_radius_topleft))
	if motion == Joystick_motion.RAXIS:
		return (joystick_motion_exceeded(Joystick_motion.RAXIS_LEFT, joystick_laxis_radius_topleft) and joystick_motion_exceeded(Joystick_motion.RAXIS_UP, joystick_laxis_radius_topleft))
	push_error('Error in joystick_motion_reached_topleft() function in VInput: Set Parameter cannot be used for calculations. Use either "LAXIS" or "RAXIS" Parameters.')
	return false
func joystick_motion_exceeded(motion: Joystick_motion, axis: float):
	return true if get_joystick_motion(motion) > axis else false
func joystick_motion_decended(motion: Joystick_motion, axis: float):
	return true if get_joystick_motion(motion) < axis else false

func set_joystick_delay_globally(time: float):
	joystick_limit_delay.fill(time)
func set_joystick_delay(button: Joystick_button, time: float):
	joystick_limit_delay[button] = time
func set_joystick_doubleclick_globally(time: float, amount: int):
	joystick_limit_doubleclick_time.fill(time)
	joystick_limit_doubleclick_amount.fill(amount)
func set_joystick_doubleclick(button: Joystick_button, time: float, amount: int):
	joystick_limit_doubleclick_time[button] = time
	joystick_limit_doubleclick_amount[button] = amount
func set_joystick_axis_radius(motion: Joystick_motion, direction: Joystick_motion_radius, amount: float):
	if motion == Joystick_motion.LAXIS:
		if direction == Joystick_motion_radius.TopRight:
			joystick_laxis_radius_topright = amount
			return
		if direction == Joystick_motion_radius.BottomRight:
			joystick_laxis_radius_bottomright = amount
			return
		if direction == Joystick_motion_radius.ButtomLeft:
			joystick_laxis_radius_bottomleft = amount
			return
		if direction == Joystick_motion_radius.TopLeft:
			joystick_laxis_radius_topleft = amount
			return
	elif motion == Joystick_motion.RAXIS:
		if direction == Joystick_motion_radius.TopRight:
			joystick_raxis_radius_topright = amount
			return
		if direction == Joystick_motion_radius.BottomRight:
			joystick_raxis_radius_bottomright = amount
			return
		if direction == Joystick_motion_radius.ButtomLeft:
			joystick_raxis_radius_bottomleft = amount
			return
		if direction == Joystick_motion_radius.TopLeft:
			joystick_raxis_radius_topleft = amount
			return
	push_error('Error in set_joystick_radius() function in VInput: "Motion" Set Parameter cannot be used for calculations. Use either "LAXIS" or "RAXIS" Parameters in place of "Motion".')
	return
func set_joystick_axis_radius_globally(motion: Joystick_motion, amount: float):
	if motion == Joystick_motion.LAXIS:
		joystick_laxis_radius_topright = amount
		joystick_laxis_radius_bottomright = amount
		joystick_laxis_radius_bottomleft = amount
		joystick_laxis_radius_topleft = amount
		return
	elif motion == Joystick_motion.RAXIS:
		joystick_raxis_radius_topright = amount
		joystick_raxis_radius_bottomright = amount
		joystick_raxis_radius_bottomleft = amount
		joystick_raxis_radius_topleft = amount
		return
	push_error('Error in set_joystick_radius_globally() function in VInput: "Motion" Set Parameter cannot be used for calculations. Use either "LAXIS" or "RAXIS" Parameters in place of "Motion".')
	return

func get_joystick_current_delay(button: Joystick_button):
	return joystick_current_delay[button]
func get_joystick_limit_delay(button: Joystick_button):
	return joystick_limit_delay[button]
func get_all_joystick_current_delays() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_current_delay[position]
	return calc
func get_all_joystick_limit_delays() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_limit_delay[position]
	return calc
func get_joystick_current_doubleclick_time(button: Joystick_button):
	return joystick_current_doubleclick_time[button]
func get_joystick_limit_doubleclick_time(button: Joystick_button):
	return joystick_limit_doubleclick_time[button]
func get_joystick_current_doubleclick_amount(button: Joystick_button):
	return joystick_current_doubleclick_amount[button]
func get_joystick_limit_doubleclick_amount(button: Joystick_button):
	return joystick_limit_doubleclick_time[button]
func get_all_joystick_current_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_current_doubleclick_time[position]
	return calc
func get_all_joystick_current_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_current_doubleclick_amount[position]
	return calc
func get_all_joystick_limit_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_limit_doubleclick_time[position]
	return calc
func get_all_joystick_limit_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_limit_doubleclick_amount[position]
	return calc
func get_joystick_motion(motion: Joystick_motion):
	return joystick_motion[motion]
	var calc = Input.get_action_raw_strength("joystick_laxis_right") - Input.get_action_raw_strength("joystick_laxis_left")
	return 0 if calc < 0.001 and calc > -0.001 else calc
func get_joystick_laxis() -> Vector2:
	return Vector2(joystick_motion[Joystick_motion.LAXIS])
	var calc = Input.get_action_raw_strength("joystick_raxis_right") - Input.get_action_raw_strength("joystick_raxis_left")
	return 0 if calc < 0.001 and calc > -0.001 else calc
func get_joystick_raxis() -> Vector2:
	return Vector2(joystick_motion[Joystick_motion.RAXIS])
func get_joystick_lt() -> float:
	return joystick_motion[Joystick_motion.LT]
func get_joystick_rt() -> float:
	return joystick_motion[Joystick_motion.RT]

func set_device_reseting_values_on_switch(change: bool):
	reset_values = change

func _process(delta):
	if current_device == Device.Mouse: return apply_mouse_pressed(delta)
	if current_device == Device.Keyboard: return apply_keyboard_pressed(delta)
	if current_device == Device.Joystick: return apply_joystick_pressed(delta)

func _unhandled_input(event):
	# Detecting what device has been active. On "current_device", whenever
	# the variable has been updated, it'll apply resets to the not current device
	# variables.
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		if current_device != Device.Mouse: current_device = Device.Mouse
	if event is InputEventKey:
		if current_device != Device.Keyboard: current_device = Device.Keyboard
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if current_device != Device.Joystick: current_device = Device.Joystick

func calculate_mouse(delta, position):
	var action = mouse_action[position]
	var current_delay = mouse_current_delay[position]
	var limit_delay = mouse_limit_delay[position]
	var current_doubleclick_time = mouse_current_doubleclick_time[position]
	var current_doubleclick_amount = mouse_current_doubleclick_amount[position]
	var limit_doubleclick_time = mouse_limit_doubleclick_time[position]
	var limit_doubleclick_amount = mouse_limit_doubleclick_amount[position]
	
	calculate_mouse_doubleclick(delta, position, current_doubleclick_time, current_doubleclick_amount)
	
	if mouse_pressed[position] == true:
		if action == Action.JustReleased or action == Action.Released:
			if current_delay != limit_delay: mouse_current_delay[position] = limit_delay
			
			mouse_action[position] = Action.JustPressed
			return mouse_button_just_pressed(position)
		
		if current_delay > 0:
			mouse_current_delay[position] -= delta
			mouse_current_delay[position] = clamp(mouse_current_delay[position], 0, limit_delay)
		
		if action == Action.JustPressed or mouse_current_delay[position] > 0:
			mouse_action[position] = Action.Pressed
			return mouse_button_pressed(position)
		
		if mouse_current_delay[position] == 0:
			if action != Action.JustHeld and action != Action.Held:
				mouse_action[position] = Action.JustHeld
				return mouse_button_just_held(position)
			
			mouse_action[position] = Action.Held
			return mouse_button_held(position)
	
	if mouse_pressed[position] == false:
		if mouse_current_delay[position] != 0: mouse_current_delay[position] = 0
		
		if action != Action.JustReleased and action != Action.Released:
			mouse_action[position] = Action.JustReleased
			return mouse_button_just_released(position)
		
		mouse_action[position] = Action.Released
		return mouse_button_released(position)
func calculate_mouse_doubleclick(delta, position: int, time: float, amount: int):
	if mouse_button_just_pressed(position):
		if amount < mouse_limit_doubleclick_amount[position]:
			mouse_current_doubleclick_amount[position] += 1
		
		if mouse_current_doubleclick_time[position] == 0 and mouse_doubleclick_action[position] == DoubleclickAction.False:
			mouse_current_doubleclick_time[position] = mouse_limit_doubleclick_time[position]
			mouse_doubleclick_action[position] = DoubleclickAction.Ongoing
			return
	
	if time > 0:
		mouse_current_doubleclick_time[position] -= delta
		mouse_current_doubleclick_time[position] = clamp(mouse_current_doubleclick_time[position], 0, mouse_limit_doubleclick_time[position])
		
		if amount == mouse_limit_doubleclick_amount[position]:
			mouse_current_doubleclick_time[position] = 0
			mouse_current_doubleclick_amount[position] = 0
			mouse_doubleclick_action[position] = DoubleclickAction.True
			return mouse_button_doubleclicked(position)
		return
	
	if time == 0:
		if mouse_doubleclick_action[position] == DoubleclickAction.Ongoing:
			if amount < mouse_limit_doubleclick_amount[position]:
				if mouse_current_doubleclick_amount[position] != 0:
					mouse_current_doubleclick_amount[position] = 0
				mouse_doubleclick_action[position] = DoubleclickAction.Failed
				return mouse_button_doubleclick_failed(position)
		
		if mouse_current_doubleclick_amount[position] != 0:
			mouse_current_doubleclick_amount[position] = 0
		if mouse_doubleclick_action[position] != DoubleclickAction.False:
			mouse_doubleclick_action[position] = DoubleclickAction.False

func calculate_keyboard(delta, position):
	var action = keyboard_action[position]
	var current_doubleclick_time = keyboard_current_doubleclick_time[position]
	var current_doubleclick_amount = keyboard_current_doubleclick_amount[position]
	var limit_doubleclick_time = keyboard_limit_doubleclick_time[position]
	var limit_doubleclick_amount = keyboard_limit_doubleclick_amount[position]
	
	calculate_keyboard_doubleclick(delta, position, current_doubleclick_time, current_doubleclick_amount)
	
	if keyboard_pressed[position] == true:
		if action == KeyboardAction.JustReleased or action == KeyboardAction.Released:
			keyboard_action[position] = KeyboardAction.JustPressed
			return keyboard_button_just_pressed(position)
		
		keyboard_action[position] = KeyboardAction.Pressed
		return keyboard_button_pressed(position)
	
	if keyboard_pressed[position] == false:
		if action != KeyboardAction.JustReleased and action != KeyboardAction.Released:
			keyboard_action[position] = KeyboardAction.JustReleased
			return keyboard_button_just_released(position)
		
		keyboard_action[position] = KeyboardAction.Released
		return keyboard_button_released(position)
func calculate_keyboard_doubleclick(delta, position: int, time: float, amount: int):
	if keyboard_button_just_pressed(position):
		if amount < keyboard_limit_doubleclick_amount[position]:
			keyboard_current_doubleclick_amount[position] += 1
		
		if keyboard_current_doubleclick_time[position] == 0 and keyboard_doubleclick_action[position] == DoubleclickAction.False:
			keyboard_current_doubleclick_time[position] = keyboard_limit_doubleclick_time[position]
			keyboard_doubleclick_action[position] = DoubleclickAction.Ongoing
			return
	
	if time > 0:
		keyboard_current_doubleclick_time[position] -= delta
		keyboard_current_doubleclick_time[position] = clamp(keyboard_current_doubleclick_time[position], 0, keyboard_limit_doubleclick_time[position])
		
		if amount == keyboard_limit_doubleclick_amount[position]:
			keyboard_current_doubleclick_time[position] = 0
			keyboard_current_doubleclick_amount[position] = 0
			keyboard_doubleclick_action[position] = DoubleclickAction.True
			return keyboard_button_doubleclicked(position)
		return
	
	if time == 0:
		if keyboard_doubleclick_action[position] == DoubleclickAction.Ongoing:
			if amount < keyboard_limit_doubleclick_amount[position]:
				if keyboard_current_doubleclick_amount[position] != 0:
					keyboard_current_doubleclick_amount[position] = 0
				keyboard_doubleclick_action[position] = DoubleclickAction.Failed
				return keyboard_button_doubleclick_failed(position)
		
		if keyboard_current_doubleclick_amount[position] != 0:
			keyboard_current_doubleclick_amount[position] = 0
		if keyboard_doubleclick_action[position] != DoubleclickAction.False:
			keyboard_doubleclick_action[position] = DoubleclickAction.False

func calculate_joystick(delta, position):
	var action = joystick_action[position]
	var current_delay = joystick_current_delay[position]
	var limit_delay = joystick_limit_delay[position]
	var current_doubleclick_time = joystick_current_doubleclick_time[position]
	var current_doubleclick_amount = joystick_current_doubleclick_amount[position]
	var limit_doubleclick_time = joystick_limit_doubleclick_time[position]
	var limit_doubleclick_amount = joystick_limit_doubleclick_amount[position]
	
	calculate_joystick_doubleclick(delta, position, current_doubleclick_time, current_doubleclick_amount)
	
	if joystick_pressed[position] == true:
		if action == Action.JustReleased or action == Action.Released:
			if current_delay != limit_delay: joystick_current_delay[position] = limit_delay
			
			joystick_action[position] = Action.JustPressed
			return joystick_button_just_pressed(position)
		
		if current_delay > 0:
			joystick_current_delay[position] -= delta
			joystick_current_delay[position] = clamp(joystick_current_delay[position], 0, limit_delay)
		
		if action == Action.JustPressed or joystick_current_delay[position] > 0:
			joystick_action[position] = Action.Pressed
			return joystick_button_pressed(position)
		
		if joystick_current_delay[position] == 0:
			if action != Action.JustHeld and action != Action.Held:
				joystick_action[position] = Action.JustHeld
				return joystick_button_just_held(position)
			
			joystick_action[position] = Action.Held
			return joystick_button_held(position)
	
	if joystick_pressed[position] == false:
		if joystick_current_delay[position] != 0: joystick_current_delay[position] = 0
		
		if action != Action.JustReleased and action != Action.Released:
			joystick_action[position] = Action.JustReleased
			return joystick_button_just_released(position)
		
		joystick_action[position] = Action.Released
		return joystick_button_released(position)
func calculate_joystick_doubleclick(delta, position: int, time: float, amount: int):
	if joystick_button_just_pressed(position):
		if amount < joystick_limit_doubleclick_amount[position]:
			joystick_current_doubleclick_amount[position] += 1
		
		if joystick_current_doubleclick_time[position] == 0 and joystick_doubleclick_action[position] == DoubleclickAction.False:
			joystick_current_doubleclick_time[position] = joystick_limit_doubleclick_time[position]
			joystick_doubleclick_action[position] = DoubleclickAction.Ongoing
			return
	
	if time > 0:
		joystick_current_doubleclick_time[position] -= delta
		joystick_current_doubleclick_time[position] = clamp(joystick_current_doubleclick_time[position], 0, joystick_limit_doubleclick_time[position])
		
		if amount == joystick_limit_doubleclick_amount[position]:
			joystick_current_doubleclick_time[position] = 0
			joystick_current_doubleclick_amount[position] = 0
			joystick_doubleclick_action[position] = DoubleclickAction.True
			return joystick_button_doubleclicked(position)
		return
	
	if time == 0:
		if joystick_doubleclick_action[position] == DoubleclickAction.Ongoing:
			if amount < joystick_limit_doubleclick_amount[position]:
				if joystick_current_doubleclick_amount[position] != 0:
					joystick_current_doubleclick_amount[position] = 0
				joystick_doubleclick_action[position] = DoubleclickAction.Failed
				return joystick_button_doubleclick_failed(position)
		
		if joystick_current_doubleclick_amount[position] != 0:
			joystick_current_doubleclick_amount[position] = 0
		if joystick_doubleclick_action[position] != DoubleclickAction.False:
			joystick_doubleclick_action[position] = DoubleclickAction.False
