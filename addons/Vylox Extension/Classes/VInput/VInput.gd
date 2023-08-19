@tool
@icon("res://addons/vylox_extension/Icons/Option.png")
extends VScript
class_name VInput

## Manipulate Inputs to your liking! Using it's rich functions and system, you get more options related
## to Mouse, Keyboard and Joystick Inputs. You can even save your current configuration, load any
## configuration and reset every option to Default!

enum Device {Mouse, Keyboard, Joystick}
enum Mouse_button {LEFT, RIGHT, MIDDLE, WHEEL_UP, WHEEL_DOWN, WHEEL_LEFT, WHEEL_RIGHT, XBUTTON1, XBUTTON2}
enum Keyboard_button {NONE, SPECIAL, ESCAPE, TAB, BACKTAB, BACKSPACE, ENTER, KP_ENTER, INSERT, DELETE, PAUSE,PRINT, SYSREQ, CLEAR, HOME, END, LEFT, UP, RIGHT, DOWN, PAGEUP, PAGEDOWN, SHIFT, CTRL, META, ALT, RIGHTALT, CAPSLOCK, NUMLOCK,SCROLLLOCK, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19, F20, F21,F22, F23, F24,F25,F26,F27,F28,F29,F30,F31,F32,F33,F34,F35,KP_MULTIPLY,KP_DIVIDE,KP_SUBTRACT,KP_PERIOD,KP_ADD,KP_0,KP_1,KP_2,KP_3,KP_4,KP_5,KP_6,KP_7,KP_8,KP_9,MENU,HYPER,HELP,BACK,FORWARD,STOP,REFRESH,VOLUMEDOWN,VOLUMEMUTE,VOLUMEUP,MEDIAPLAY,MEDIASTOP,MEDIAPREVIOUS,MEDIANEXT,MEDIARECORD,HOMEPAGE,FAVORITES,SEARCH,STANDBY,OPENURL,LAUNCHMAIL,LAUNCHMEDIA,LAUNCH0,LAUNCH1,LAUNCH2,LAUNCH3,LAUNCH4,LAUNCH5,LAUNCH6,LAUNCH7,LAUNCH8,LAUNCH9,LAUNCHA,LAUNCHB,LAUNCHC,LAUNCHD,LAUNCHE,LAUNCHF,UNKNOWN,SPACE,EXCLAM,QUOTEDBL,NUMBERSIGN,DOLLAR,PERCENT,AMPERSAND,APOSTROPHE,PARENLEFT,PARENRIGHT,ASTERISK,PLUS,COMMA,MINUS,PERIOD,SLASH,NUMBER_0,NUMBER_1,NUMBER_2,NUMBER_3,NUMBER_4,NUMBER_5,NUMBER_6,NUMBER_7,NUMBER_8,NUMBER_9,COLON,SEMICOLON,LESS,EQUAL,GREATER,QUESTION,AT,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,BRACKETLEFT,BACKSLASH,BRACKETRIGHT,ASCIICIRCUM,UNDERSCORE,QUOTELEFT,BRACELEFT,BAR,BRACERIGHT,ASCIITILDE,YEN,SECTION,GLOBE,KEYBOARD,JIS_EISU,JIS_KANA}
enum Joystick_button {A, B, X, Y, LB, RB, LT, RT, START, BACK, CONNECTION_BUTTON, LAXIS_BUTTON, RAXIS_BUTTON, DPAD_UP, DPAD_DOWN, DPAD_LEFT, DPAD_RIGHT, LAXIS_UP, LAXIS_DOWN, LAXIS_LEFT, LAXIS_RIGHT, RAXIS_UP, RAXIS_DOWN, RAXIS_LEFT, RAXIS_RIGHT}
enum Joystick_motion {LT, RT, LAXIS_UP, LAXIS_DOWN, LAXIS_LEFT, LAXIS_RIGHT, RAXIS_UP, RAXIS_DOWN, RAXIS_LEFT, RAXIS_RIGHT, LAXIS, RAXIS}
enum Action {JustPressed, Pressed, JustHeld, Held, JustReleased, Released}
enum KeyboardAction {JustPressed, Pressed, JustReleased, Released}
enum DoubleclickAction {False, Ongoing, Failed, True}
enum Joystick_motion_radius {TopRight, BottomRight, ButtomLeft, TopLeft}

var working: bool = false

var mouse_pressed: Array = [false, false, false, false, false, false, false, false, false]
var keyboard_pressed: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]
var joystick_pressed: Array = [false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false, false]

var mouse_active: bool = true:
	set(value):
		mouse_active = value
		if keyboard_active != false: keyboard_active = false
		if joystick_active != false: joystick_active = false
var keyboard_active: bool = false:
	set(value):
		keyboard_active = value
		if mouse_active != false: mouse_active = false
		if joystick_active != false: joystick_active = false
var joystick_active: bool = false:
	set(value):
		joystick_active = value
		if mouse_active != false: mouse_active = false
		if keyboard_active != false: keyboard_active = false

var mouse_action: Array = [Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released]
var mouse_current_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0]
var mouse_current_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0]
var mouse_current_delay: PackedFloat64Array = [0,0,0,0,0,0,0,0,0]
var mouse_doubleclick_action: PackedInt64Array = [0,0,0,0,0,0,0,0,0]
var mouse_limit_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0]
var mouse_limit_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0]
var mouse_limit_delay: PackedFloat64Array = [0,0,0,0,0,0,0,0,0]
var mouse_motion: Vector2 = Input.get_last_mouse_velocity()

var keyboard_action: Array = [Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released]
var keyboard_current_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0]
var keyboard_current_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0]
var keyboard_doubleclick_action: PackedInt64Array = [DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False]
var keyboard_limit_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0]
var keyboard_limit_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0]

var joystick_action: Array = [Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released,Action.Released, Action.Released,Action.Released,Action.Released,Action.Released,Action.Released]
var joystick_current_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
var joystick_current_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
var joystick_current_delay: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
var joystick_doubleclick_action: PackedInt64Array = [DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False, DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False,DoubleclickAction.False]
var joystick_limit_doubleclick_time: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
var joystick_limit_doubleclick_amount: PackedInt64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
var joystick_limit_delay: PackedFloat64Array = [0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0]
var joystick_motion: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, Vector2(0, 0), Vector2(0, 0)]
var joystick_laxis_radius_topright: float = 0.25
var joystick_laxis_radius_bottomright: float = 0.25
var joystick_laxis_radius_bottomleft: float = 0.25
var joystick_laxis_radius_topleft: float = 0.25
var joystick_raxis_radius_topright: float = 0.25
var joystick_raxis_radius_bottomright: float = 0.25
var joystick_raxis_radius_bottomleft: float = 0.25
var joystick_raxis_radius_topleft: float = 0.25

var reset_values: bool = false

var current_device: int = 0:
	set(value):
		current_device = value
		if reset_values:
			match current_device:
				Device.Mouse: set_joystick_values()
				Device.Keyboard: set_joystick_values()
				Device.Joystick:
					set_mouse_values()
					set_keyboard_values()
var default_device: int = 0


enum config_mouse_choise {None, AllInputs, SeparateInputs}
var m_delay_input_choise: int = config_mouse_choise.None:
	set(value):
		m_delay_input_choise = value
		m_delay_input_choise = clamp(m_delay_input_choise, 0, config_mouse_choise.keys().size())
var m_doubleclick_time_input_choise: int = config_mouse_choise.None:
	set(value):
		m_doubleclick_time_input_choise = value
		m_doubleclick_time_input_choise = clamp(m_doubleclick_time_input_choise, 0, config_mouse_choise.keys().size())
var m_doubleclick_amount_input_choise: int = config_mouse_choise.None:
	set(value):
		m_doubleclick_amount_input_choise = value
		m_doubleclick_amount_input_choise = clamp(m_doubleclick_amount_input_choise, 0, config_mouse_choise.keys().size())

enum config_mouse_separate_input_option {None, Left_Mouse_Button, Right_Mouse_Button, Middle_Mouse_Button, Wheel_Up_Trigger, Wheel_Down_Trigger, Wheel_Left_Trigger, Wheel_Right_Trigger, Special_Button_1, Special_Button_2}
var m_delay_input_option: int = config_mouse_separate_input_option.None:
	set(value):
		m_delay_input_option = value
		m_delay_input_option = clamp(m_delay_input_option, 0, config_mouse_separate_input_option.keys().size())
var m_doubleclick_time_input_option: int = config_mouse_separate_input_option.None:
	set(value):
		m_doubleclick_time_input_option = value
		m_doubleclick_time_input_option = clamp(m_doubleclick_time_input_option, 0, config_mouse_separate_input_option.keys().size())
var m_doubleclick_amount_input_option: int = config_mouse_separate_input_option.None:
	set(value):
		m_doubleclick_amount_input_option = value
		m_doubleclick_amount_input_option = clamp(m_doubleclick_amount_input_option, 0, config_mouse_separate_input_option.keys().size())


enum config_keyboard_choise {None, AllInputs, SeparateInputs}
var k_delay_input_choise: int = config_keyboard_choise.None:
	set(value):
		k_delay_input_choise = value
		k_delay_input_choise = clamp(k_delay_input_choise, 0, config_keyboard_choise.keys().size())
var k_doubleclick_time_input_choise: int = config_keyboard_choise.None:
	set(value):
		k_doubleclick_time_input_choise = value
		k_doubleclick_time_input_choise = clamp(k_doubleclick_time_input_choise, 0, config_keyboard_choise.keys().size())
var k_doubleclick_amount_input_choise: int = config_keyboard_choise.None:
	set(value):
		k_doubleclick_amount_input_choise = value
		k_doubleclick_amount_input_choise = clamp(k_doubleclick_amount_input_choise, 0, config_keyboard_choise.keys().size())

enum config_keyboard_separate_option {None, Letters, Numbers, FKeys, LeftSideSpecialKeys, Arrows, RightSideSpecialKeys, NumericPartKeys}
var k_delay_input_option: int = config_keyboard_separate_option.None:
	set(value):
		k_delay_input_option = value
		k_delay_input_option = clamp(k_delay_input_option, 0, config_keyboard_separate_option.keys().size())
var k_doubleclick_time_input_option: int = config_keyboard_separate_option.None:
	set(value):
		k_doubleclick_time_input_option = value
		k_doubleclick_time_input_option = clamp(k_doubleclick_time_input_option, 0, config_keyboard_separate_option.keys().size())
var k_doubleclick_amount_input_option: int = config_keyboard_separate_option.None:
	set(value):
		k_doubleclick_amount_input_option = value
		k_doubleclick_amount_input_option = clamp(k_doubleclick_amount_input_option, 0, config_keyboard_separate_option.keys().size())

enum config_keyboard_letters {None, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z}
var k_delay_keyboard_letter_option: int = config_keyboard_letters.None:
	set(value):
		k_delay_keyboard_letter_option = value
		k_delay_keyboard_letter_option = clamp(k_delay_keyboard_letter_option, 0, config_keyboard_letters.keys().size())
var k_doubleclick_time_keyboard_letter_option: int = config_keyboard_letters.None:
	set(value):
		k_doubleclick_time_keyboard_letter_option = value
		k_doubleclick_time_keyboard_letter_option = clamp(k_doubleclick_time_keyboard_letter_option, 0, config_keyboard_letters.keys().size())
var k_doubleclick_amount_keyboard_letter_option: int = config_keyboard_letters.None:
	set(value):
		k_doubleclick_amount_keyboard_letter_option = value
		k_doubleclick_amount_keyboard_letter_option = clamp(k_doubleclick_amount_keyboard_letter_option, 0, config_keyboard_letters.keys().size())

enum config_keyboard_numbers {None, Number_0, Number_1, Number_2, Number_3, Number_4, Number_5, Number_6, Number_7, Number_8, Number_9}
var k_delay_keyboard_number_option: int = config_keyboard_numbers.None:
	set(value):
		k_delay_keyboard_number_option = value
		k_delay_keyboard_number_option = clamp(k_delay_keyboard_number_option, 0, config_keyboard_numbers.keys().size())
var k_doubleclick_time_keyboard_number_option: int = config_keyboard_numbers.None:
	set(value):
		k_doubleclick_time_keyboard_number_option = value
		k_doubleclick_time_keyboard_number_option = clamp(k_doubleclick_time_keyboard_number_option, 0, config_keyboard_numbers.keys().size())
var k_doubleclick_amount_keyboard_number_option: int = config_keyboard_numbers.None:
	set(value):
		k_doubleclick_amount_keyboard_number_option = value
		k_doubleclick_amount_keyboard_number_option = clamp(k_doubleclick_amount_keyboard_number_option, 0, config_keyboard_numbers.keys().size())

enum config_keyboard_F_keys {None, F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12}
var k_delay_keyboard_f_key_option: int = config_keyboard_F_keys.None:
	set(value):
		k_delay_keyboard_f_key_option = value
		k_delay_keyboard_f_key_option = clamp(k_delay_keyboard_f_key_option, 0, config_keyboard_F_keys.keys().size())
var k_doubleclick_time_keyboard_f_key_option: int = config_keyboard_F_keys.None:
	set(value):
		k_doubleclick_time_keyboard_f_key_option = value
		k_doubleclick_time_keyboard_f_key_option = clamp(k_doubleclick_time_keyboard_f_key_option, 0, config_keyboard_F_keys.keys().size())
var k_doubleclick_amount_keyboard_f_key_option: int = config_keyboard_F_keys.None:
	set(value):
		k_doubleclick_amount_keyboard_f_key_option = value
		k_doubleclick_amount_keyboard_f_key_option = clamp(k_doubleclick_amount_keyboard_f_key_option, 0, config_keyboard_F_keys.keys().size())

enum config_keyboard_left_special_keys {None, Escape, Tab, Capslock, Shift, Ctrl, Left_alt, Right_alt, Meta, Space, Menu, Enter, Backspace, Comma, Period, Minus, Left_Quote, Slash, Equal, Left_Bracket, Right_Bracket, Semicolon, Apostrophe, Backslash}
var k_delay_keyboard_left_special_key_option: int = config_keyboard_left_special_keys.None:
	set(value):
		k_delay_keyboard_left_special_key_option = value
		k_delay_keyboard_left_special_key_option = clamp(k_delay_keyboard_left_special_key_option, 0, config_keyboard_left_special_keys.keys().size())
var k_doubleclick_time_keyboard_left_special_key_option: int = config_keyboard_left_special_keys.None:
	set(value):
		k_doubleclick_time_keyboard_left_special_key_option = value
		k_doubleclick_time_keyboard_left_special_key_option = clamp(k_doubleclick_time_keyboard_left_special_key_option, 0, config_keyboard_left_special_keys.keys().size())
var k_doubleclick_amount_keyboard_left_special_key_option: int = config_keyboard_left_special_keys.None:
	set(value):
		k_doubleclick_amount_keyboard_left_special_key_option = value
		k_doubleclick_amount_keyboard_left_special_key_option = clamp(k_doubleclick_amount_keyboard_left_special_key_option, 0, config_keyboard_left_special_keys.keys().size())

enum config_keyboard_arrows {None, Up_Arrow, Down_Arrow, Left_Arrow, Right_Arrow}
var k_delay_keyboard_arrow_option: int = config_keyboard_arrows.None:
	set(value):
		k_delay_keyboard_arrow_option = value
		k_delay_keyboard_arrow_option = clamp(k_delay_keyboard_arrow_option, 0, config_keyboard_arrows.keys().size())
var k_doubleclick_time_keyboard_arrow_option: int = config_keyboard_arrows.None:
	set(value):
		k_doubleclick_time_keyboard_arrow_option = value
		k_doubleclick_time_keyboard_arrow_option = clamp(k_doubleclick_time_keyboard_arrow_option, 0, config_keyboard_arrows.keys().size())
var k_doubleclick_amount_keyboard_arrow_option: int = config_keyboard_arrows.None:
	set(value):
		k_doubleclick_amount_keyboard_arrow_option = value
		k_doubleclick_amount_keyboard_arrow_option = clamp(k_doubleclick_amount_keyboard_arrow_option, 0, config_keyboard_arrows.keys().size())

enum config_keyboard_right_special_keys {None, Delete, Insert, Home, End, Page_Up, Page_Down, Scrolllock, Pause}
var k_delay_keyboard_right_special_key_option: int = config_keyboard_right_special_keys.None:
	set(value):
		k_delay_keyboard_right_special_key_option = value
		k_delay_keyboard_right_special_key_option = clamp(k_delay_keyboard_right_special_key_option, 0, config_keyboard_right_special_keys.keys().size())
var k_doubleclick_time_keyboard_right_special_key_option: int = config_keyboard_right_special_keys.None:
	set(value):
		k_doubleclick_time_keyboard_right_special_key_option = value
		k_doubleclick_time_keyboard_right_special_key_option = clamp(k_doubleclick_time_keyboard_right_special_key_option, 0, config_keyboard_right_special_keys.keys().size())
var k_doubleclick_amount_keyboard_right_special_key_option: int = config_keyboard_right_special_keys.None:
	set(value):
		k_doubleclick_amount_keyboard_right_special_key_option = value
		k_doubleclick_amount_keyboard_right_special_key_option = clamp(k_doubleclick_amount_keyboard_right_special_key_option, 0, config_keyboard_right_special_keys.keys().size())

enum config_keyboard_KP_keys {None, KP_Number_0, KP_Number_1, KP_Number_2, KP_Number_3, KP_Number_4, KP_Number_5, KP_Number_6, KP_Number_7, KP_Number_8, KP_Number_9, KP_Period, KP_Enter, KP_Add, KP_Subtract, KP_Multiply, KP_Divide, KP_Numlock}
var k_delay_keyboard_KP_key_option: int = config_keyboard_KP_keys.None:
	set(value):
		k_delay_keyboard_KP_key_option = value
		k_delay_keyboard_KP_key_option = clamp(k_delay_keyboard_KP_key_option, 0, config_keyboard_KP_keys.keys().size())
var k_doubleclick_time_keyboard_KP_key_option: int = config_keyboard_KP_keys.None:
	set(value):
		k_doubleclick_time_keyboard_KP_key_option = value
		k_doubleclick_time_keyboard_KP_key_option = clamp(k_doubleclick_time_keyboard_KP_key_option, 0, config_keyboard_KP_keys.keys().size())
var k_doubleclick_amount_keyboard_KP_key_option: int = config_keyboard_KP_keys.None:
	set(value):
		k_doubleclick_amount_keyboard_KP_key_option = value
		k_doubleclick_amount_keyboard_KP_key_option = clamp(k_doubleclick_amount_keyboard_KP_key_option, 0, config_keyboard_KP_keys.keys().size())

enum config_joystick_choise {None, AllInputs, SeparateInputs}
var j_delay_input_choise: int = config_joystick_choise.None:
	set(value):
		j_delay_input_choise = value
		j_delay_input_choise = clamp(j_delay_input_choise, 0, config_joystick_choise.keys().size())
var j_doubleclick_time_input_choise: int = config_joystick_choise.None:
	set(value):
		j_doubleclick_time_input_choise = value
		j_doubleclick_time_input_choise = clamp(j_doubleclick_time_input_choise, 0, config_joystick_choise.keys().size())
var j_doubleclick_amount_input_choise: int = config_joystick_choise.None:
	set(value):
		j_doubleclick_amount_input_choise = value
		j_doubleclick_amount_input_choise = clamp(j_doubleclick_amount_input_choise, 0, config_joystick_choise.keys().size())
var j_doubleclick_motion_input_choise: int = config_joystick_choise.None:
	set(value):
		j_doubleclick_motion_input_choise = value
		j_doubleclick_motion_input_choise = clamp(j_doubleclick_motion_input_choise, 0, config_joystick_choise.keys().size())

enum config_joystick_input_option {None, A, B, X, Y, Left_Bumper, Right_Bumper, Left_Trigger, Right_Trigger, Start, Back, Connection, Left_Stick_Button, Right_Stick_Button, Dpad_Up, Dpad_Down, Dpad_Left, Dpad_Right, Left_Stick_Up, Left_Stick_Down, Left_Stick_Left, Left_Stick_Right, Right_Stick_Up, Right_Stick_Down, Right_Stick_Left, Right_Stick_Right}
var j_delay_input_option: int = config_joystick_input_option.None:
	set(value):
		j_delay_input_option = value
		j_delay_input_option = clamp(j_delay_input_option, 0, config_joystick_input_option.keys().size())
var j_doubleclick_time_input_option: int = config_joystick_input_option.None:
	set(value):
		j_doubleclick_time_input_option = value
		j_doubleclick_time_input_option = clamp(j_doubleclick_time_input_option, 0, config_joystick_input_option.keys().size())
var j_doubleclick_amount_input_option: int = config_joystick_input_option.None:
	set(value):
		j_doubleclick_amount_input_option = value
		j_doubleclick_amount_input_option = clamp(j_doubleclick_amount_input_option, 0, config_joystick_input_option.keys().size())

enum config_joystick_motion_category {None, Left_Stick, Right_Stick, All_Sticks}
var j_motion_button_category: int = config_joystick_motion_category.None:
	set(value):
		j_motion_button_category = value
		j_motion_button_category = clamp(j_motion_button_category, 0, config_joystick_motion_category.keys().size())

enum config_joystick_motion_left_stick_option {None, Top_Right_Side, Bottom_Right_Side, Top_Left_Side, Bottom_Left_Side}
var j_motion_button_left_stick_option: int = config_joystick_motion_left_stick_option.None:
	set(value):
		j_motion_button_left_stick_option = value
		j_motion_button_left_stick_option = clamp(j_motion_button_left_stick_option, 0, config_joystick_motion_left_stick_option.keys().size())

enum config_joystick_motion_right_stick_option {None, Top_Right_Side, Bottom_Right_Side, Top_Left_Side, Bottom_Left_Side}
var j_motion_button_right_stick_option: int = config_joystick_motion_right_stick_option.None:
	set(value):
		j_motion_button_right_stick_option = value
		j_motion_button_right_stick_option = clamp(j_motion_button_right_stick_option, 0, config_joystick_motion_right_stick_option.keys().size())

var m_delay_value_for_left_mouse_button: float:
	set(value):
		m_delay_value_for_left_mouse_button = value
		set_mouse_delay(Mouse_button.LEFT, value)
var m_delay_value_for_right_mouse_button: float:
	set(value):
		m_delay_value_for_right_mouse_button = value
		set_mouse_delay(Mouse_button.RIGHT, value)
var m_delay_value_for_middle_mouse_button: float:
	set(value):
		m_delay_value_for_middle_mouse_button = value
		set_mouse_delay(Mouse_button.MIDDLE, value)
var m_delay_value_for_wheel_up_trigger: float:
	set(value):
		m_delay_value_for_wheel_up_trigger = value
		set_mouse_delay(Mouse_button.WHEEL_UP, value)
var m_delay_value_for_wheel_down_trigger: float:
	set(value):
		m_delay_value_for_wheel_down_trigger = value
		set_mouse_delay(Mouse_button.WHEEL_DOWN, value)
var m_delay_value_for_wheel_left_trigger: float:
	set(value):
		m_delay_value_for_wheel_left_trigger = value
		set_mouse_delay(Mouse_button.WHEEL_LEFT, value)
var m_delay_value_for_wheel_right_trigger: float:
	set(value):
		m_delay_value_for_wheel_right_trigger = value
		set_mouse_delay(Mouse_button.WHEEL_RIGHT, value)
var m_delay_value_for_special_button_1: float:
	set(value):
		m_delay_value_for_special_button_1 = value
		set_mouse_delay(Mouse_button.XBUTTON1, value)
var m_delay_value_for_special_button_2: float:
	set(value):
		m_delay_value_for_special_button_2 = value
		set_mouse_delay(Mouse_button.XBUTTON2, value)
var m_delay_value_for_all_mouse_inputs: float:
	set(value):
		m_delay_value_for_all_mouse_inputs = value
		set_mouse_delay_globally(value)

var m_doubleclick_time_value_for_left_mouse_button: float:
	set(value):
		m_doubleclick_time_value_for_left_mouse_button = value
		set_mouse_doubleclick_time(Mouse_button.LEFT, value)
var m_doubleclick_time_value_for_right_mouse_button: float:
	set(value):
		m_doubleclick_time_value_for_right_mouse_button = value
		set_mouse_doubleclick_time(Mouse_button.RIGHT, value)
var m_doubleclick_time_value_for_middle_mouse_button: float:
	set(value):
		m_doubleclick_time_value_for_middle_mouse_button = value
		set_mouse_doubleclick_time(Mouse_button.MIDDLE, value)
var m_doubleclick_time_value_for_wheel_up_trigger: float:
	set(value):
		m_doubleclick_time_value_for_wheel_up_trigger = value
		set_mouse_doubleclick_time(Mouse_button.WHEEL_UP, value)
var m_doubleclick_time_value_for_wheel_down_trigger: float:
	set(value):
		m_doubleclick_time_value_for_wheel_down_trigger = value
		set_mouse_doubleclick_time(Mouse_button.WHEEL_DOWN, value)
var m_doubleclick_time_value_for_wheel_left_trigger: float:
	set(value):
		m_doubleclick_time_value_for_wheel_left_trigger = value
		set_mouse_doubleclick_time(Mouse_button.WHEEL_LEFT, value)
var m_doubleclick_time_value_for_wheel_right_trigger: float:
	set(value):
		m_doubleclick_time_value_for_wheel_right_trigger = value
		set_mouse_doubleclick_time(Mouse_button.WHEEL_RIGHT, value)
var m_doubleclick_time_value_for_special_button_1: float:
	set(value):
		m_doubleclick_time_value_for_special_button_1 = value
		set_mouse_doubleclick_time(Mouse_button.XBUTTON1, value)
var m_doubleclick_time_value_for_special_button_2: float:
	set(value):
		m_doubleclick_time_value_for_special_button_2 = value
		set_mouse_doubleclick_time(Mouse_button.XBUTTON2, value)
var m_doubleclick_time_value_for_all_mouse_inputs: float:
	set(value):
		m_doubleclick_time_value_for_all_mouse_inputs = value
		set_mouse_doubleclick_time_globally(value)

var m_doubleclick_amount_value_for_left_mouse_button: float:
	set(value):
		m_doubleclick_amount_value_for_left_mouse_button = value
		set_mouse_doubleclick_amount(Mouse_button.LEFT, value)
var m_doubleclick_amount_value_for_right_mouse_button: float:
	set(value):
		m_doubleclick_amount_value_for_right_mouse_button = value
		set_mouse_doubleclick_amount(Mouse_button.RIGHT, value)
var m_doubleclick_amount_value_for_middle_mouse_button: float:
	set(value):
		m_doubleclick_amount_value_for_middle_mouse_button = value
		set_mouse_doubleclick_amount(Mouse_button.MIDDLE, value)
var m_doubleclick_amount_value_for_wheel_up_trigger: float:
	set(value):
		m_doubleclick_amount_value_for_wheel_up_trigger = value
		set_mouse_doubleclick_amount(Mouse_button.WHEEL_UP, value)
var m_doubleclick_amount_value_for_wheel_down_trigger: float:
	set(value):
		m_doubleclick_amount_value_for_wheel_down_trigger = value
		set_mouse_doubleclick_amount(Mouse_button.WHEEL_DOWN, value)
var m_doubleclick_amount_value_for_wheel_left_trigger: float:
	set(value):
		m_doubleclick_amount_value_for_wheel_left_trigger = value
		set_mouse_doubleclick_amount(Mouse_button.WHEEL_LEFT, value)
var m_doubleclick_amount_value_for_wheel_right_trigger: float:
	set(value):
		m_doubleclick_amount_value_for_wheel_right_trigger = value
		set_mouse_doubleclick_amount(Mouse_button.WHEEL_RIGHT, value)
var m_doubleclick_amount_value_for_special_button_1: float:
	set(value):
		m_doubleclick_amount_value_for_special_button_1 = value
		set_mouse_doubleclick_amount(Mouse_button.XBUTTON1, value)
var m_doubleclick_amount_value_for_special_button_2: float:
	set(value):
		m_doubleclick_amount_value_for_special_button_2 = value
		set_mouse_doubleclick_amount(Mouse_button.XBUTTON2, value)
var m_doubleclick_amount_value_for_all_mouse_inputs: float:
	set(value):
		m_doubleclick_amount_value_for_all_mouse_inputs = value
		set_mouse_doubleclick_amount_globally(value)


var k_doubleclick_time_value_for_button_A: float:
	set(value):
		k_doubleclick_time_value_for_button_A = value
		set_keyboard_doubleclick_time(Keyboard_button.A, value)
var k_doubleclick_time_value_for_button_B: float:
	set(value):
		k_doubleclick_time_value_for_button_B = value
		set_keyboard_doubleclick_time(Keyboard_button.B, value)
var k_doubleclick_time_value_for_button_C: float:
	set(value):
		k_doubleclick_time_value_for_button_C = value
		set_keyboard_doubleclick_time(Keyboard_button.C, value)
var k_doubleclick_time_value_for_button_D: float:
	set(value):
		k_doubleclick_time_value_for_button_D = value
		set_keyboard_doubleclick_time(Keyboard_button.D, value)
var k_doubleclick_time_value_for_button_E: float:
	set(value):
		k_doubleclick_time_value_for_button_E = value
		set_keyboard_doubleclick_time(Keyboard_button.E, value)
var k_doubleclick_time_value_for_button_F: float:
	set(value):
		k_doubleclick_time_value_for_button_F = value
		set_keyboard_doubleclick_time(Keyboard_button.F, value)
var k_doubleclick_time_value_for_button_G: float:
	set(value):
		k_doubleclick_time_value_for_button_G = value
		set_keyboard_doubleclick_time(Keyboard_button.G, value)
var k_doubleclick_time_value_for_button_H: float:
	set(value):
		k_doubleclick_time_value_for_button_H = value
		set_keyboard_doubleclick_time(Keyboard_button.H, value)
var k_doubleclick_time_value_for_button_I: float:
	set(value):
		k_doubleclick_time_value_for_button_I = value
		set_keyboard_doubleclick_time(Keyboard_button.I, value)
var k_doubleclick_time_value_for_button_J: float:
	set(value):
		k_doubleclick_time_value_for_button_J = value
		set_keyboard_doubleclick_time(Keyboard_button.J, value)
var k_doubleclick_time_value_for_button_K: float:
	set(value):
		k_doubleclick_time_value_for_button_K = value
		set_keyboard_doubleclick_time(Keyboard_button.K, value)
var k_doubleclick_time_value_for_button_L: float:
	set(value):
		k_doubleclick_time_value_for_button_L = value
		set_keyboard_doubleclick_time(Keyboard_button.L, value)
var k_doubleclick_time_value_for_button_M: float:
	set(value):
		k_doubleclick_time_value_for_button_M = value
		set_keyboard_doubleclick_time(Keyboard_button.M, value)
var k_doubleclick_time_value_for_button_N: float:
	set(value):
		k_doubleclick_time_value_for_button_N = value
		set_keyboard_doubleclick_time(Keyboard_button.N, value)
var k_doubleclick_time_value_for_button_O: float:
	set(value):
		k_doubleclick_time_value_for_button_O = value
		set_keyboard_doubleclick_time(Keyboard_button.O, value)
var k_doubleclick_time_value_for_button_P: float:
	set(value):
		k_doubleclick_time_value_for_button_P = value
		set_keyboard_doubleclick_time(Keyboard_button.P, value)
var k_doubleclick_time_value_for_button_Q: float:
	set(value):
		k_doubleclick_time_value_for_button_Q = value
		set_keyboard_doubleclick_time(Keyboard_button.Q, value)
var k_doubleclick_time_value_for_button_R: float:
	set(value):
		k_doubleclick_time_value_for_button_R = value
		set_keyboard_doubleclick_time(Keyboard_button.R, value)
var k_doubleclick_time_value_for_button_S: float:
	set(value):
		k_doubleclick_time_value_for_button_S = value
		set_keyboard_doubleclick_time(Keyboard_button.S, value)
var k_doubleclick_time_value_for_button_T: float:
	set(value):
		k_doubleclick_time_value_for_button_T = value
		set_keyboard_doubleclick_time(Keyboard_button.T, value)
var k_doubleclick_time_value_for_button_U: float:
	set(value):
		k_doubleclick_time_value_for_button_U = value
		set_keyboard_doubleclick_time(Keyboard_button.U, value)
var k_doubleclick_time_value_for_button_V: float:
	set(value):
		k_doubleclick_time_value_for_button_V = value
		set_keyboard_doubleclick_time(Keyboard_button.V, value)
var k_doubleclick_time_value_for_button_W: float:
	set(value):
		k_doubleclick_time_value_for_button_W = value
		set_keyboard_doubleclick_time(Keyboard_button.W, value)
var k_doubleclick_time_value_for_button_X: float:
	set(value):
		k_doubleclick_time_value_for_button_X = value
		set_keyboard_doubleclick_time(Keyboard_button.X, value)
var k_doubleclick_time_value_for_button_Y: float:
	set(value):
		k_doubleclick_time_value_for_button_Y = value
		set_keyboard_doubleclick_time(Keyboard_button.Y, value)
var k_doubleclick_time_value_for_button_Z: float:
	set(value):
		k_doubleclick_time_value_for_button_Z = value
		set_keyboard_doubleclick_time(Keyboard_button.Z, value)

var k_doubleclick_time_value_for_button_0: float:
	set(value):
		k_doubleclick_time_value_for_button_0 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_0, value)
var k_doubleclick_time_value_for_button_1: float:
	set(value):
		k_doubleclick_time_value_for_button_1 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_1, value)
var k_doubleclick_time_value_for_button_2: float:
	set(value):
		k_doubleclick_time_value_for_button_2 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_2, value)
var k_doubleclick_time_value_for_button_3: float:
	set(value):
		k_doubleclick_time_value_for_button_3 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_3, value)
var k_doubleclick_time_value_for_button_4: float:
	set(value):
		k_doubleclick_time_value_for_button_4 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_4, value)
var k_doubleclick_time_value_for_button_5: float:
	set(value):
		k_doubleclick_time_value_for_button_5 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_5, value)
var k_doubleclick_time_value_for_button_6: float:
	set(value):
		k_doubleclick_time_value_for_button_6 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_6, value)
var k_doubleclick_time_value_for_button_7: float:
	set(value):
		k_doubleclick_time_value_for_button_7 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_7, value)
var k_doubleclick_time_value_for_button_8: float:
	set(value):
		k_doubleclick_time_value_for_button_8 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_8, value)
var k_doubleclick_time_value_for_button_9: float:
	set(value):
		k_doubleclick_time_value_for_button_9 = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMBER_9, value)

var k_doubleclick_time_value_for_numeric_button_0: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_0 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_0, value)
var k_doubleclick_time_value_for_numeric_button_1: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_1 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_1, value)
var k_doubleclick_time_value_for_numeric_button_2: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_2 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_2, value)
var k_doubleclick_time_value_for_numeric_button_3: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_3 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_3, value)
var k_doubleclick_time_value_for_numeric_button_4: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_4 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_4, value)
var k_doubleclick_time_value_for_numeric_button_5: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_5 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_5, value)
var k_doubleclick_time_value_for_numeric_button_6: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_6 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_6, value)
var k_doubleclick_time_value_for_numeric_button_7: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_7 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_7, value)
var k_doubleclick_time_value_for_numeric_button_8: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_8 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_8, value)
var k_doubleclick_time_value_for_numeric_button_9: float:
	set(value):
		k_doubleclick_time_value_for_numeric_button_9 = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_9, value)
var k_doubleclick_time_value_for_enter_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_enter_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_ENTER, value)
var k_doubleclick_time_value_for_add_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_add_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_ADD, value)
var k_doubleclick_time_value_for_subtract_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_subtract_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_SUBTRACT, value)
var k_doubleclick_time_value_for_multiply_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_multiply_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_MULTIPLY, value)
var k_doubleclick_time_value_for_divide_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_divide_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_DIVIDE, value)
var k_doubleclick_time_value_for_period_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_period_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.KP_PERIOD, value)
var k_doubleclick_time_value_for_numlock_numeric_button: float:
	set(value):
		k_doubleclick_time_value_for_numlock_numeric_button = value
		set_keyboard_doubleclick_time(Keyboard_button.NUMLOCK, value)

var k_doubleclick_time_value_for_up_arrow: float:
	set(value):
		k_doubleclick_time_value_for_up_arrow = value
		set_keyboard_doubleclick_time(Keyboard_button.UP, value)
var k_doubleclick_time_value_for_down_arrow: float:
	set(value):
		k_doubleclick_time_value_for_down_arrow = value
		set_keyboard_doubleclick_time(Keyboard_button.DOWN, value)
var k_doubleclick_time_value_for_left_arrow: float:
	set(value):
		k_doubleclick_time_value_for_left_arrow = value
		set_keyboard_doubleclick_time(Keyboard_button.LEFT, value)
var k_doubleclick_time_value_for_right_arrow: float:
	set(value):
		k_doubleclick_time_value_for_right_arrow = value
		set_keyboard_doubleclick_time(Keyboard_button.RIGHT, value)

var k_doubleclick_time_value_for_f1: float:
	set(value):
		k_doubleclick_time_value_for_f1 = value
		set_keyboard_doubleclick_time(Keyboard_button.F1, value)
var k_doubleclick_time_value_for_f2: float:
	set(value):
		k_doubleclick_time_value_for_f2 = value
		set_keyboard_doubleclick_time(Keyboard_button.F2, value)
var k_doubleclick_time_value_for_f3: float:
	set(value):
		k_doubleclick_time_value_for_f3 = value
		set_keyboard_doubleclick_time(Keyboard_button.F3, value)
var k_doubleclick_time_value_for_f4: float:
	set(value):
		k_doubleclick_time_value_for_f4 = value
		set_keyboard_doubleclick_time(Keyboard_button.F4, value)
var k_doubleclick_time_value_for_f5: float:
	set(value):
		k_doubleclick_time_value_for_f5 = value
		set_keyboard_doubleclick_time(Keyboard_button.F5, value)
var k_doubleclick_time_value_for_f6: float:
	set(value):
		k_doubleclick_time_value_for_f6 = value
		set_keyboard_doubleclick_time(Keyboard_button.F6, value)
var k_doubleclick_time_value_for_f7: float:
	set(value):
		k_doubleclick_time_value_for_f7 = value
		set_keyboard_doubleclick_time(Keyboard_button.F7, value)
var k_doubleclick_time_value_for_f8: float:
	set(value):
		k_doubleclick_time_value_for_f8 = value
		set_keyboard_doubleclick_time(Keyboard_button.F8, value)
var k_doubleclick_time_value_for_f9: float:
	set(value):
		k_doubleclick_time_value_for_f9 = value
		set_keyboard_doubleclick_time(Keyboard_button.F9, value)
var k_doubleclick_time_value_for_f10: float:
	set(value):
		k_doubleclick_time_value_for_f10 = value
		set_keyboard_doubleclick_time(Keyboard_button.F10, value)
var k_doubleclick_time_value_for_f11: float:
	set(value):
		k_doubleclick_time_value_for_f11 = value
		set_keyboard_doubleclick_time(Keyboard_button.F11, value)
var k_doubleclick_time_value_for_f12: float:
	set(value):
		k_doubleclick_time_value_for_f12 = value
		set_keyboard_doubleclick_time(Keyboard_button.F12, value)

var k_doubleclick_time_value_for_escape_button: float:
	set(value):
		k_doubleclick_time_value_for_escape_button = value
		set_keyboard_doubleclick_time(Keyboard_button.ESCAPE, value)
var k_doubleclick_time_value_for_tab_button: float:
	set(value):
		k_doubleclick_time_value_for_tab_button = value
		set_keyboard_doubleclick_time(Keyboard_button.TAB, value)
var k_doubleclick_time_value_for_capslock_button: float:
	set(value):
		k_doubleclick_time_value_for_capslock_button = value
		set_keyboard_doubleclick_time(Keyboard_button.CAPSLOCK, value)
var k_doubleclick_time_value_for_shift_button: float:
	set(value):
		k_doubleclick_time_value_for_shift_button = value
		set_keyboard_doubleclick_time(Keyboard_button.SHIFT, value)
var k_doubleclick_time_value_for_ctrl_button: float:
	set(value):
		k_doubleclick_time_value_for_ctrl_button = value
		set_keyboard_doubleclick_time(Keyboard_button.CTRL, value)
var k_doubleclick_time_value_for_left_alt_button: float:
	set(value):
		k_doubleclick_time_value_for_left_alt_button = value
		set_keyboard_doubleclick_time(Keyboard_button.ALT, value)
var k_doubleclick_time_value_for_right_alt_button: float:
	set(value):
		k_doubleclick_time_value_for_right_alt_button = value
		set_keyboard_doubleclick_time(Keyboard_button.RIGHTALT, value)
var k_doubleclick_time_value_for_enter_button: float:
	set(value):
		k_doubleclick_time_value_for_enter_button = value
		set_keyboard_doubleclick_time(Keyboard_button.ENTER, value)
var k_doubleclick_time_value_for_backspace_button: float:
	set(value):
		k_doubleclick_time_value_for_backspace_button = value
		set_keyboard_doubleclick_time(Keyboard_button.BACKSPACE, value)
var k_doubleclick_time_value_for_special_button: float:
	set(value):
		k_doubleclick_time_value_for_special_button = value
		set_keyboard_doubleclick_time(Keyboard_button.SPECIAL, value)
var k_doubleclick_time_value_for_bar_button: float:
	set(value):
		k_doubleclick_time_value_for_bar_button = value
		set_keyboard_doubleclick_time(Keyboard_button.BAR, value)
var k_doubleclick_time_value_for_comma_button: float:
	set(value):
		k_doubleclick_time_value_for_comma_button = value
		set_keyboard_doubleclick_time(Keyboard_button.COMMA, value)
var k_doubleclick_time_value_for_period_button: float:
	set(value):
		k_doubleclick_time_value_for_period_button = value
		set_keyboard_doubleclick_time(Keyboard_button.PERIOD, value)
var k_doubleclick_time_value_for_minus_button: float:
	set(value):
		k_doubleclick_time_value_for_minus_button = value
		set_keyboard_doubleclick_time(Keyboard_button.MINUS, value)
var k_doubleclick_time_value_for_menu_button: float:
	set(value):
		k_doubleclick_time_value_for_menu_button = value
		set_keyboard_doubleclick_time(Keyboard_button.MENU, value)
var k_doubleclick_time_value_for_meta_button: float:
	set(value):
		k_doubleclick_time_value_for_meta_button = value
		set_keyboard_doubleclick_time(Keyboard_button.META, value)
var k_doubleclick_time_value_for_left_quote_button: float:
	set(value):
		k_doubleclick_time_value_for_left_quote_button = value
		set_keyboard_doubleclick_time(Keyboard_button.QUOTELEFT, value)
var k_doubleclick_time_value_for_slash_button: float:
	set(value):
		k_doubleclick_time_value_for_slash_button = value
		set_keyboard_doubleclick_time(Keyboard_button.SLASH, value)
var k_doubleclick_time_value_for_equal_button: float:
	set(value):
		k_doubleclick_time_value_for_equal_button = value
		set_keyboard_doubleclick_time(Keyboard_button.EQUAL, value)
var k_doubleclick_time_value_for_left_bracket_button: float:
	set(value):
		k_doubleclick_time_value_for_left_bracket_button = value
		set_keyboard_doubleclick_time(Keyboard_button.BRACKETLEFT, value)
var k_doubleclick_time_value_for_right_bracket_button: float:
	set(value):
		k_doubleclick_time_value_for_right_bracket_button = value
		set_keyboard_doubleclick_time(Keyboard_button.BRACKETRIGHT, value)
var k_doubleclick_time_value_for_semicolon_button: float:
	set(value):
		k_doubleclick_time_value_for_semicolon_button = value
		set_keyboard_doubleclick_time(Keyboard_button.SEMICOLON, value)
var k_doubleclick_time_value_for_apostrophe_button: float:
	set(value):
		k_doubleclick_time_value_for_apostrophe_button = value
		set_keyboard_doubleclick_time(Keyboard_button.APOSTROPHE, value)
var k_doubleclick_time_value_for_backslash_button: float:
	set(value):
		k_doubleclick_time_value_for_backslash_button = value
		set_keyboard_doubleclick_time(Keyboard_button.BACKSLASH, value)
var k_doubleclick_time_value_for_space_button: float:
	set(value):
		k_doubleclick_time_value_for_space_button = value
		set_keyboard_doubleclick_time(Keyboard_button.SPACE, value)

var k_doubleclick_time_value_for_insert_button: float:
	set(value):
		k_doubleclick_time_value_for_insert_button = value
		set_keyboard_doubleclick_time(Keyboard_button.INSERT, value)
var k_doubleclick_time_value_for_home_button: float:
	set(value):
		k_doubleclick_time_value_for_home_button = value
		set_keyboard_doubleclick_time(Keyboard_button.HOME, value)
var k_doubleclick_time_value_for_end_button: float:
	set(value):
		k_doubleclick_time_value_for_end_button = value
		set_keyboard_doubleclick_time(Keyboard_button.END, value)
var k_doubleclick_time_value_for_delete_button: float:
	set(value):
		k_doubleclick_time_value_for_delete_button = value
		set_keyboard_doubleclick_time(Keyboard_button.DELETE, value)
var k_doubleclick_time_value_for_page_up_button: float:
	set(value):
		k_doubleclick_time_value_for_page_up_button = value
		set_keyboard_doubleclick_time(Keyboard_button.PAGEUP, value)
var k_doubleclick_time_value_for_page_down_button: float:
	set(value):
		k_doubleclick_time_value_for_page_down_button = value
		set_keyboard_doubleclick_time(Keyboard_button.PAGEDOWN, value)
var k_doubleclick_time_value_for_scrolllock_button: float:
	set(value):
		k_doubleclick_time_value_for_scrolllock_button = value
		set_keyboard_doubleclick_time(Keyboard_button.SCROLLLOCK, value)
var k_doubleclick_time_value_for_pause_button: float:
	set(value):
		k_doubleclick_time_value_for_pause_button = value
		set_keyboard_doubleclick_time(Keyboard_button.PAUSE, value)

var k_doubleclick_time_value_for_all_keyboard_inputs: float:
	set(value):
		k_doubleclick_time_value_for_all_keyboard_inputs = value
		set_keyboard_doubleclick_time_globally(value)


var k_doubleclick_amount_value_for_button_A: float:
	set(value):
		k_doubleclick_amount_value_for_button_A = value
		set_keyboard_doubleclick_amount(Keyboard_button.A, value)
var k_doubleclick_amount_value_for_button_B: float:
	set(value):
		k_doubleclick_amount_value_for_button_B = value
		set_keyboard_doubleclick_amount(Keyboard_button.B, value)
var k_doubleclick_amount_value_for_button_C: float:
	set(value):
		k_doubleclick_amount_value_for_button_C = value
		set_keyboard_doubleclick_amount(Keyboard_button.C, value)
var k_doubleclick_amount_value_for_button_D: float:
	set(value):
		k_doubleclick_amount_value_for_button_D = value
		set_keyboard_doubleclick_amount(Keyboard_button.D, value)
var k_doubleclick_amount_value_for_button_E: float:
	set(value):
		k_doubleclick_amount_value_for_button_E = value
		set_keyboard_doubleclick_amount(Keyboard_button.E, value)
var k_doubleclick_amount_value_for_button_F: float:
	set(value):
		k_doubleclick_amount_value_for_button_F = value
		set_keyboard_doubleclick_amount(Keyboard_button.F, value)
var k_doubleclick_amount_value_for_button_G: float:
	set(value):
		k_doubleclick_amount_value_for_button_G = value
		set_keyboard_doubleclick_amount(Keyboard_button.G, value)
var k_doubleclick_amount_value_for_button_H: float:
	set(value):
		k_doubleclick_amount_value_for_button_H = value
		set_keyboard_doubleclick_amount(Keyboard_button.H, value)
var k_doubleclick_amount_value_for_button_I: float:
	set(value):
		k_doubleclick_amount_value_for_button_I = value
		set_keyboard_doubleclick_amount(Keyboard_button.I, value)
var k_doubleclick_amount_value_for_button_J: float:
	set(value):
		k_doubleclick_amount_value_for_button_J = value
		set_keyboard_doubleclick_amount(Keyboard_button.J, value)
var k_doubleclick_amount_value_for_button_K: float:
	set(value):
		k_doubleclick_amount_value_for_button_K = value
		set_keyboard_doubleclick_amount(Keyboard_button.K, value)
var k_doubleclick_amount_value_for_button_L: float:
	set(value):
		k_doubleclick_amount_value_for_button_L = value
		set_keyboard_doubleclick_amount(Keyboard_button.L, value)
var k_doubleclick_amount_value_for_button_M: float:
	set(value):
		k_doubleclick_amount_value_for_button_M = value
		set_keyboard_doubleclick_amount(Keyboard_button.M, value)
var k_doubleclick_amount_value_for_button_N: float:
	set(value):
		k_doubleclick_amount_value_for_button_N = value
		set_keyboard_doubleclick_amount(Keyboard_button.N, value)
var k_doubleclick_amount_value_for_button_O: float:
	set(value):
		k_doubleclick_amount_value_for_button_O = value
		set_keyboard_doubleclick_amount(Keyboard_button.O, value)
var k_doubleclick_amount_value_for_button_P: float:
	set(value):
		k_doubleclick_amount_value_for_button_P = value
		set_keyboard_doubleclick_amount(Keyboard_button.P, value)
var k_doubleclick_amount_value_for_button_Q: float:
	set(value):
		k_doubleclick_amount_value_for_button_Q = value
		set_keyboard_doubleclick_amount(Keyboard_button.Q, value)
var k_doubleclick_amount_value_for_button_R: float:
	set(value):
		k_doubleclick_amount_value_for_button_R = value
		set_keyboard_doubleclick_amount(Keyboard_button.R, value)
var k_doubleclick_amount_value_for_button_S: float:
	set(value):
		k_doubleclick_amount_value_for_button_S = value
		set_keyboard_doubleclick_amount(Keyboard_button.S, value)
var k_doubleclick_amount_value_for_button_T: float:
	set(value):
		k_doubleclick_amount_value_for_button_T = value
		set_keyboard_doubleclick_amount(Keyboard_button.T, value)
var k_doubleclick_amount_value_for_button_U: float:
	set(value):
		k_doubleclick_amount_value_for_button_U = value
		set_keyboard_doubleclick_amount(Keyboard_button.U, value)
var k_doubleclick_amount_value_for_button_V: float:
	set(value):
		k_doubleclick_amount_value_for_button_V = value
		set_keyboard_doubleclick_amount(Keyboard_button.V, value)
var k_doubleclick_amount_value_for_button_W: float:
	set(value):
		k_doubleclick_amount_value_for_button_W = value
		set_keyboard_doubleclick_amount(Keyboard_button.W, value)
var k_doubleclick_amount_value_for_button_X: float:
	set(value):
		k_doubleclick_amount_value_for_button_X = value
		set_keyboard_doubleclick_amount(Keyboard_button.X, value)
var k_doubleclick_amount_value_for_button_Y: float:
	set(value):
		k_doubleclick_amount_value_for_button_Y = value
		set_keyboard_doubleclick_amount(Keyboard_button.Y, value)
var k_doubleclick_amount_value_for_button_Z: float:
	set(value):
		k_doubleclick_amount_value_for_button_Z = value
		set_keyboard_doubleclick_amount(Keyboard_button.Z, value)

var k_doubleclick_amount_value_for_button_0: float:
	set(value):
		k_doubleclick_amount_value_for_button_0 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_0, value)
var k_doubleclick_amount_value_for_button_1: float:
	set(value):
		k_doubleclick_amount_value_for_button_1 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_1, value)
var k_doubleclick_amount_value_for_button_2: float:
	set(value):
		k_doubleclick_amount_value_for_button_2 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_2, value)
var k_doubleclick_amount_value_for_button_3: float:
	set(value):
		k_doubleclick_amount_value_for_button_3 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_3, value)
var k_doubleclick_amount_value_for_button_4: float:
	set(value):
		k_doubleclick_amount_value_for_button_4 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_4, value)
var k_doubleclick_amount_value_for_button_5: float:
	set(value):
		k_doubleclick_amount_value_for_button_5 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_5, value)
var k_doubleclick_amount_value_for_button_6: float:
	set(value):
		k_doubleclick_amount_value_for_button_6 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_6, value)
var k_doubleclick_amount_value_for_button_7: float:
	set(value):
		k_doubleclick_amount_value_for_button_7 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_7, value)
var k_doubleclick_amount_value_for_button_8: float:
	set(value):
		k_doubleclick_amount_value_for_button_8 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_8, value)
var k_doubleclick_amount_value_for_button_9: float:
	set(value):
		k_doubleclick_amount_value_for_button_9 = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMBER_9, value)

var k_doubleclick_amount_value_for_numeric_button_0: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_0 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_0, value)
var k_doubleclick_amount_value_for_numeric_button_1: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_1 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_1, value)
var k_doubleclick_amount_value_for_numeric_button_2: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_2 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_2, value)
var k_doubleclick_amount_value_for_numeric_button_3: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_3 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_3, value)
var k_doubleclick_amount_value_for_numeric_button_4: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_4 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_4, value)
var k_doubleclick_amount_value_for_numeric_button_5: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_5 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_5, value)
var k_doubleclick_amount_value_for_numeric_button_6: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_6 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_6, value)
var k_doubleclick_amount_value_for_numeric_button_7: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_7 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_7, value)
var k_doubleclick_amount_value_for_numeric_button_8: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_8 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_8, value)
var k_doubleclick_amount_value_for_numeric_button_9: float:
	set(value):
		k_doubleclick_amount_value_for_numeric_button_9 = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_9, value)
var k_doubleclick_amount_value_for_enter_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_enter_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_ENTER, value)
var k_doubleclick_amount_value_for_add_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_add_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_ADD, value)
var k_doubleclick_amount_value_for_subtract_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_subtract_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_SUBTRACT, value)
var k_doubleclick_amount_value_for_multiply_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_multiply_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_MULTIPLY, value)
var k_doubleclick_amount_value_for_divide_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_divide_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_DIVIDE, value)
var k_doubleclick_amount_value_for_period_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_period_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.KP_PERIOD, value)
var k_doubleclick_amount_value_for_numlock_numeric_button: float:
	set(value):
		k_doubleclick_amount_value_for_numlock_numeric_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.NUMLOCK, value)

var k_doubleclick_amount_value_for_up_arrow: float:
	set(value):
		k_doubleclick_amount_value_for_up_arrow = value
		set_keyboard_doubleclick_amount(Keyboard_button.UP, value)
var k_doubleclick_amount_value_for_down_arrow: float:
	set(value):
		k_doubleclick_amount_value_for_down_arrow = value
		set_keyboard_doubleclick_amount(Keyboard_button.DOWN, value)
var k_doubleclick_amount_value_for_left_arrow: float:
	set(value):
		k_doubleclick_amount_value_for_left_arrow = value
		set_keyboard_doubleclick_amount(Keyboard_button.LEFT, value)
var k_doubleclick_amount_value_for_right_arrow: float:
	set(value):
		k_doubleclick_amount_value_for_right_arrow = value
		set_keyboard_doubleclick_amount(Keyboard_button.RIGHT, value)

var k_doubleclick_amount_value_for_f1: float:
	set(value):
		k_doubleclick_amount_value_for_f1 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F1, value)
var k_doubleclick_amount_value_for_f2: float:
	set(value):
		k_doubleclick_amount_value_for_f2 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F2, value)
var k_doubleclick_amount_value_for_f3: float:
	set(value):
		k_doubleclick_amount_value_for_f3 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F3, value)
var k_doubleclick_amount_value_for_f4: float:
	set(value):
		k_doubleclick_amount_value_for_f4 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F4, value)
var k_doubleclick_amount_value_for_f5: float:
	set(value):
		k_doubleclick_amount_value_for_f5 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F5, value)
var k_doubleclick_amount_value_for_f6: float:
	set(value):
		k_doubleclick_amount_value_for_f6 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F6, value)
var k_doubleclick_amount_value_for_f7: float:
	set(value):
		k_doubleclick_amount_value_for_f7 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F7, value)
var k_doubleclick_amount_value_for_f8: float:
	set(value):
		k_doubleclick_amount_value_for_f8 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F8, value)
var k_doubleclick_amount_value_for_f9: float:
	set(value):
		k_doubleclick_amount_value_for_f9 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F9, value)
var k_doubleclick_amount_value_for_f10: float:
	set(value):
		k_doubleclick_amount_value_for_f10 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F10, value)
var k_doubleclick_amount_value_for_f11: float:
	set(value):
		k_doubleclick_amount_value_for_f11 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F11, value)
var k_doubleclick_amount_value_for_f12: float:
	set(value):
		k_doubleclick_amount_value_for_f12 = value
		set_keyboard_doubleclick_amount(Keyboard_button.F12, value)

var k_doubleclick_amount_value_for_escape_button: float:
	set(value):
		k_doubleclick_amount_value_for_escape_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.ESCAPE, value)
var k_doubleclick_amount_value_for_tab_button: float:
	set(value):
		k_doubleclick_amount_value_for_tab_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.TAB, value)
var k_doubleclick_amount_value_for_capslock_button: float:
	set(value):
		k_doubleclick_amount_value_for_capslock_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.CAPSLOCK, value)
var k_doubleclick_amount_value_for_shift_button: float:
	set(value):
		k_doubleclick_amount_value_for_shift_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.SHIFT, value)
var k_doubleclick_amount_value_for_ctrl_button: float:
	set(value):
		k_doubleclick_amount_value_for_ctrl_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.CTRL, value)
var k_doubleclick_amount_value_for_left_alt_button: float:
	set(value):
		k_doubleclick_amount_value_for_left_alt_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.ALT, value)
var k_doubleclick_amount_value_for_right_alt_button: float:
	set(value):
		k_doubleclick_amount_value_for_right_alt_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.RIGHTALT, value)
var k_doubleclick_amount_value_for_enter_button: float:
	set(value):
		k_doubleclick_amount_value_for_enter_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.ENTER, value)
var k_doubleclick_amount_value_for_backspace_button: float:
	set(value):
		k_doubleclick_amount_value_for_backspace_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.BACKSPACE, value)
var k_doubleclick_amount_value_for_special_button: float:
	set(value):
		k_doubleclick_amount_value_for_special_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.SPECIAL, value)
var k_doubleclick_amount_value_for_bar_button: float:
	set(value):
		k_doubleclick_amount_value_for_bar_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.BAR, value)
var k_doubleclick_amount_value_for_comma_button: float:
	set(value):
		k_doubleclick_amount_value_for_comma_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.COMMA, value)
var k_doubleclick_amount_value_for_period_button: float:
	set(value):
		k_doubleclick_amount_value_for_period_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.PERIOD, value)
var k_doubleclick_amount_value_for_minus_button: float:
	set(value):
		k_doubleclick_amount_value_for_minus_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.MINUS, value)
var k_doubleclick_amount_value_for_menu_button: float:
	set(value):
		k_doubleclick_amount_value_for_menu_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.MENU, value)
var k_doubleclick_amount_value_for_meta_button: float:
	set(value):
		k_doubleclick_amount_value_for_meta_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.META, value)
var k_doubleclick_amount_value_for_left_quote_button: float:
	set(value):
		k_doubleclick_amount_value_for_left_quote_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.QUOTELEFT, value)
var k_doubleclick_amount_value_for_slash_button: float:
	set(value):
		k_doubleclick_amount_value_for_slash_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.SLASH, value)
var k_doubleclick_amount_value_for_equal_button: float:
	set(value):
		k_doubleclick_amount_value_for_equal_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.EQUAL, value)
var k_doubleclick_amount_value_for_left_bracket_button: float:
	set(value):
		k_doubleclick_amount_value_for_left_bracket_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.BRACKETLEFT, value)
var k_doubleclick_amount_value_for_right_bracket_button: float:
	set(value):
		k_doubleclick_amount_value_for_right_bracket_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.BRACKETRIGHT, value)
var k_doubleclick_amount_value_for_semicolon_button: float:
	set(value):
		k_doubleclick_amount_value_for_semicolon_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.SEMICOLON, value)
var k_doubleclick_amount_value_for_apostrophe_button: float:
	set(value):
		k_doubleclick_amount_value_for_apostrophe_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.APOSTROPHE, value)
var k_doubleclick_amount_value_for_backslash_button: float:
	set(value):
		k_doubleclick_amount_value_for_backslash_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.BACKSLASH, value)
var k_doubleclick_amount_value_for_space_button: float:
	set(value):
		k_doubleclick_amount_value_for_space_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.SPACE, value)

var k_doubleclick_amount_value_for_insert_button: float:
	set(value):
		k_doubleclick_amount_value_for_insert_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.INSERT, value)
var k_doubleclick_amount_value_for_home_button: float:
	set(value):
		k_doubleclick_amount_value_for_home_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.HOME, value)
var k_doubleclick_amount_value_for_end_button: float:
	set(value):
		k_doubleclick_amount_value_for_end_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.END, value)
var k_doubleclick_amount_value_for_delete_button: float:
	set(value):
		k_doubleclick_amount_value_for_delete_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.DELETE, value)
var k_doubleclick_amount_value_for_page_up_button: float:
	set(value):
		k_doubleclick_amount_value_for_page_up_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.PAGEUP, value)
var k_doubleclick_amount_value_for_page_down_button: float:
	set(value):
		k_doubleclick_amount_value_for_page_down_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.PAGEDOWN, value)
var k_doubleclick_amount_value_for_scrolllock_button: float:
	set(value):
		k_doubleclick_amount_value_for_scrolllock_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.SCROLLLOCK, value)
var k_doubleclick_amount_value_for_pause_button: float:
	set(value):
		k_doubleclick_amount_value_for_pause_button = value
		set_keyboard_doubleclick_amount(Keyboard_button.PAUSE, value)

var k_doubleclick_amount_value_for_all_keyboard_inputs: float:
	set(value):
		k_doubleclick_amount_value_for_all_keyboard_inputs = value
		set_keyboard_doubleclick_amount_globally(value)


var j_delay_value_for_a: float:
	set(value):
		j_delay_value_for_a = value
		set_joystick_delay(Joystick_button.A, value)
var j_delay_value_for_b: float:
	set(value):
		j_delay_value_for_b = value
		set_joystick_delay(Joystick_button.A, value)
var j_delay_value_for_x: float:
	set(value):
		j_delay_value_for_x = value
		set_joystick_delay(Joystick_button.X, value)
var j_delay_value_for_y: float:
	set(value):
		j_delay_value_for_y = value
		set_joystick_delay(Joystick_button.Y, value)

var j_delay_value_for_left_trigger: float:
	set(value):
		j_delay_value_for_left_trigger = value
		set_joystick_delay(Joystick_button.LT, value)
var j_delay_value_for_right_trigger: float:
	set(value):
		j_delay_value_for_right_trigger = value
		set_joystick_delay(Joystick_button.RT, value)
var j_delay_value_for_left_bumper: float:
	set(value):
		j_delay_value_for_left_bumper = value
		set_joystick_delay(Joystick_button.LB, value)
var j_delay_value_for_right_bumper: float:
	set(value):
		j_delay_value_for_right_bumper = value
		set_joystick_delay(Joystick_button.RB, value)

var j_delay_value_for_back: float:
	set(value):
		j_delay_value_for_back = value
		set_joystick_delay(Joystick_button.BACK, value)
var j_delay_value_for_start: float:
	set(value):
		j_delay_value_for_start = value
		set_joystick_delay(Joystick_button.START, value)
var j_delay_value_for_connection: float:
	set(value):
		j_delay_value_for_connection = value
		set_joystick_delay(Joystick_button.CONNECTION_BUTTON, value)

var j_delay_value_for_left_stick_button: float:
	set(value):
		j_delay_value_for_left_stick_button = value
		set_joystick_delay(Joystick_button.LAXIS_BUTTON, value)
var j_delay_value_for_right_stick_button: float:
	set(value):
		j_delay_value_for_right_stick_button = value
		set_joystick_delay(Joystick_button.RAXIS_BUTTON, value)
var j_delay_value_for_left_stick_up: float:
	set(value):
		j_delay_value_for_left_stick_up = value
		set_joystick_delay(Joystick_button.LAXIS_UP, value)
var j_delay_value_for_left_stick_down: float:
	set(value):
		j_delay_value_for_left_stick_down = value
		set_joystick_delay(Joystick_button.LAXIS_DOWN, value)
var j_delay_value_for_left_stick_left: float:
	set(value):
		j_delay_value_for_left_stick_left = value
		set_joystick_delay(Joystick_button.LAXIS_LEFT, value)
var j_delay_value_for_left_stick_right: float:
	set(value):
		j_delay_value_for_left_stick_right = value
		set_joystick_delay(Joystick_button.LAXIS_RIGHT, value)
var j_delay_value_for_right_stick_up: float:
	set(value):
		j_delay_value_for_right_stick_up = value
		set_joystick_delay(Joystick_button.RAXIS_UP, value)
var j_delay_value_for_right_stick_down: float:
	set(value):
		j_delay_value_for_right_stick_down = value
		set_joystick_delay(Joystick_button.RAXIS_DOWN, value)
var j_delay_value_for_right_stick_left: float:
	set(value):
		j_delay_value_for_right_stick_left = value
		set_joystick_delay(Joystick_button.RAXIS_LEFT, value)
var j_delay_value_for_right_stick_right: float:
	set(value):
		j_delay_value_for_right_stick_right = value
		set_joystick_delay(Joystick_button.RAXIS_RIGHT, value)

var j_delay_value_for_dpad_up: float:
	set(value):
		j_delay_value_for_dpad_up = value
		set_joystick_delay(Joystick_button.DPAD_UP, value)
var j_delay_value_for_dpad_down: float:
	set(value):
		j_delay_value_for_dpad_down = value
		set_joystick_delay(Joystick_button.DPAD_DOWN, value)
var j_delay_value_for_dpad_left: float:
	set(value):
		j_delay_value_for_dpad_left = value
		set_joystick_delay(Joystick_button.DPAD_LEFT, value)
var j_delay_value_for_dpad_right: float:
	set(value):
		j_delay_value_for_dpad_right = value
		set_joystick_delay(Joystick_button.DPAD_RIGHT, value)

var j_delay_value_for_all_joystick_buttons: float:
	set(value):
		j_delay_value_for_all_joystick_buttons = value
		set_joystick_delay_globally(value)

var j_doubleclick_time_value_for_a: float:
	set(value):
		j_doubleclick_time_value_for_a = value
		set_joystick_doubleclick_time(Joystick_button.A, value)
var j_doubleclick_time_value_for_b: float:
	set(value):
		j_doubleclick_time_value_for_b = value
		set_joystick_doubleclick_time(Joystick_button.A, value)
var j_doubleclick_time_value_for_x: float:
	set(value):
		j_doubleclick_time_value_for_x = value
		set_joystick_doubleclick_time(Joystick_button.X, value)
var j_doubleclick_time_value_for_y: float:
	set(value):
		j_doubleclick_time_value_for_y = value
		set_joystick_doubleclick_time(Joystick_button.Y, value)

var j_doubleclick_time_value_for_left_trigger: float:
	set(value):
		j_doubleclick_time_value_for_left_trigger = value
		set_joystick_doubleclick_time(Joystick_button.LT, value)
var j_doubleclick_time_value_for_right_trigger: float:
	set(value):
		j_doubleclick_time_value_for_right_trigger = value
		set_joystick_doubleclick_time(Joystick_button.RT, value)
var j_doubleclick_time_value_for_left_bumper: float:
	set(value):
		j_doubleclick_time_value_for_left_bumper = value
		set_joystick_doubleclick_time(Joystick_button.LB, value)
var j_doubleclick_time_value_for_right_bumper: float:
	set(value):
		j_doubleclick_time_value_for_right_bumper = value
		set_joystick_doubleclick_time(Joystick_button.RB, value)

var j_doubleclick_time_value_for_back: float:
	set(value):
		j_doubleclick_time_value_for_back = value
		set_joystick_doubleclick_time(Joystick_button.BACK, value)
var j_doubleclick_time_value_for_start: float:
	set(value):
		j_doubleclick_time_value_for_start = value
		set_joystick_doubleclick_time(Joystick_button.START, value)
var j_doubleclick_time_value_for_connection: float:
	set(value):
		j_doubleclick_time_value_for_connection = value
		set_joystick_doubleclick_time(Joystick_button.CONNECTION_BUTTON, value)

var j_doubleclick_time_value_for_left_stick_button: float:
	set(value):
		j_doubleclick_time_value_for_left_stick_button = value
		set_joystick_doubleclick_time(Joystick_button.LAXIS_BUTTON, value)
var j_doubleclick_time_value_for_right_stick_button: float:
	set(value):
		j_doubleclick_time_value_for_right_stick_button = value
		set_joystick_doubleclick_time(Joystick_button.RAXIS_BUTTON, value)
var j_doubleclick_time_value_for_left_stick_up: float:
	set(value):
		j_doubleclick_time_value_for_left_stick_up = value
		set_joystick_doubleclick_time(Joystick_button.LAXIS_UP, value)
var j_doubleclick_time_value_for_left_stick_down: float:
	set(value):
		j_doubleclick_time_value_for_left_stick_down = value
		set_joystick_doubleclick_time(Joystick_button.LAXIS_DOWN, value)
var j_doubleclick_time_value_for_left_stick_left: float:
	set(value):
		j_doubleclick_time_value_for_left_stick_left = value
		set_joystick_doubleclick_time(Joystick_button.LAXIS_LEFT, value)
var j_doubleclick_time_value_for_left_stick_right: float:
	set(value):
		j_doubleclick_time_value_for_left_stick_right = value
		set_joystick_doubleclick_time(Joystick_button.LAXIS_RIGHT, value)
var j_doubleclick_time_value_for_right_stick_up: float:
	set(value):
		j_doubleclick_time_value_for_right_stick_up = value
		set_joystick_doubleclick_time(Joystick_button.RAXIS_UP, value)
var j_doubleclick_time_value_for_right_stick_down: float:
	set(value):
		j_doubleclick_time_value_for_right_stick_down = value
		set_joystick_doubleclick_time(Joystick_button.RAXIS_DOWN, value)
var j_doubleclick_time_value_for_right_stick_left: float:
	set(value):
		j_doubleclick_time_value_for_right_stick_left = value
		set_joystick_doubleclick_time(Joystick_button.RAXIS_LEFT, value)
var j_doubleclick_time_value_for_right_stick_right: float:
	set(value):
		j_doubleclick_time_value_for_right_stick_right = value
		set_joystick_doubleclick_time(Joystick_button.RAXIS_RIGHT, value)

var j_doubleclick_time_value_for_dpad_up: float:
	set(value):
		j_doubleclick_time_value_for_dpad_up = value
		set_joystick_doubleclick_time(Joystick_button.DPAD_UP, value)
var j_doubleclick_time_value_for_dpad_down: float:
	set(value):
		j_doubleclick_time_value_for_dpad_down = value
		set_joystick_doubleclick_time(Joystick_button.DPAD_DOWN, value)
var j_doubleclick_time_value_for_dpad_left: float:
	set(value):
		j_doubleclick_time_value_for_dpad_left = value
		set_joystick_doubleclick_time(Joystick_button.DPAD_LEFT, value)
var j_doubleclick_time_value_for_dpad_right: float:
	set(value):
		j_doubleclick_time_value_for_dpad_right = value
		set_joystick_doubleclick_time(Joystick_button.DPAD_RIGHT, value)

var j_doubleclick_time_value_for_all_joystick_buttons: float:
	set(value):
		j_doubleclick_time_value_for_all_joystick_buttons = value
		set_joystick_doubleclick_time_globally(value)

var j_doubleclick_amount_value_for_a: float:
	set(value):
		j_doubleclick_amount_value_for_a = value
		set_joystick_doubleclick_amount(Joystick_button.A, value)
var j_doubleclick_amount_value_for_b: float:
	set(value):
		j_doubleclick_amount_value_for_b = value
		set_joystick_doubleclick_amount(Joystick_button.A, value)
var j_doubleclick_amount_value_for_x: float:
	set(value):
		j_doubleclick_amount_value_for_x = value
		set_joystick_doubleclick_amount(Joystick_button.X, value)
var j_doubleclick_amount_value_for_y: float:
	set(value):
		j_doubleclick_amount_value_for_y = value
		set_joystick_doubleclick_amount(Joystick_button.Y, value)

var j_doubleclick_amount_value_for_left_trigger: float:
	set(value):
		j_doubleclick_amount_value_for_left_trigger = value
		set_joystick_doubleclick_amount(Joystick_button.LT, value)
var j_doubleclick_amount_value_for_right_trigger: float:
	set(value):
		j_doubleclick_amount_value_for_right_trigger = value
		set_joystick_doubleclick_amount(Joystick_button.RT, value)
var j_doubleclick_amount_value_for_left_bumper: float:
	set(value):
		j_doubleclick_amount_value_for_left_bumper = value
		set_joystick_doubleclick_amount(Joystick_button.LB, value)
var j_doubleclick_amount_value_for_right_bumper: float:
	set(value):
		j_doubleclick_amount_value_for_right_bumper = value
		set_joystick_doubleclick_amount(Joystick_button.RB, value)

var j_doubleclick_amount_value_for_back: float:
	set(value):
		j_doubleclick_amount_value_for_back = value
		set_joystick_doubleclick_amount(Joystick_button.BACK, value)
var j_doubleclick_amount_value_for_start: float:
	set(value):
		j_doubleclick_amount_value_for_start = value
		set_joystick_doubleclick_amount(Joystick_button.START, value)
var j_doubleclick_amount_value_for_connection: float:
	set(value):
		j_doubleclick_amount_value_for_connection = value
		set_joystick_doubleclick_amount(Joystick_button.CONNECTION_BUTTON, value)

var j_doubleclick_amount_value_for_left_stick_button: float:
	set(value):
		j_doubleclick_amount_value_for_left_stick_button = value
		set_joystick_doubleclick_amount(Joystick_button.LAXIS_BUTTON, value)
var j_doubleclick_amount_value_for_right_stick_button: float:
	set(value):
		j_doubleclick_amount_value_for_right_stick_button = value
		set_joystick_doubleclick_amount(Joystick_button.RAXIS_BUTTON, value)
var j_doubleclick_amount_value_for_left_stick_up: float:
	set(value):
		j_doubleclick_amount_value_for_left_stick_up = value
		set_joystick_doubleclick_amount(Joystick_button.LAXIS_UP, value)
var j_doubleclick_amount_value_for_left_stick_down: float:
	set(value):
		j_doubleclick_amount_value_for_left_stick_down = value
		set_joystick_doubleclick_amount(Joystick_button.LAXIS_DOWN, value)
var j_doubleclick_amount_value_for_left_stick_left: float:
	set(value):
		j_doubleclick_amount_value_for_left_stick_left = value
		set_joystick_doubleclick_amount(Joystick_button.LAXIS_LEFT, value)
var j_doubleclick_amount_value_for_left_stick_right: float:
	set(value):
		j_doubleclick_amount_value_for_left_stick_right = value
		set_joystick_doubleclick_amount(Joystick_button.LAXIS_RIGHT, value)
var j_doubleclick_amount_value_for_right_stick_up: float:
	set(value):
		j_doubleclick_amount_value_for_right_stick_up = value
		set_joystick_doubleclick_amount(Joystick_button.RAXIS_UP, value)
var j_doubleclick_amount_value_for_right_stick_down: float:
	set(value):
		j_doubleclick_amount_value_for_right_stick_down = value
		set_joystick_doubleclick_amount(Joystick_button.RAXIS_DOWN, value)
var j_doubleclick_amount_value_for_right_stick_left: float:
	set(value):
		j_doubleclick_amount_value_for_right_stick_left = value
		set_joystick_doubleclick_amount(Joystick_button.RAXIS_LEFT, value)
var j_doubleclick_amount_value_for_right_stick_right: float:
	set(value):
		j_doubleclick_amount_value_for_right_stick_right = value
		set_joystick_doubleclick_amount(Joystick_button.RAXIS_RIGHT, value)

var j_doubleclick_amount_value_for_dpad_up: float:
	set(value):
		j_doubleclick_amount_value_for_dpad_up = value
		set_joystick_doubleclick_amount(Joystick_button.DPAD_UP, value)
var j_doubleclick_amount_value_for_dpad_down: float:
	set(value):
		j_doubleclick_amount_value_for_dpad_down = value
		set_joystick_doubleclick_amount(Joystick_button.DPAD_DOWN, value)
var j_doubleclick_amount_value_for_dpad_left: float:
	set(value):
		j_doubleclick_amount_value_for_dpad_left = value
		set_joystick_doubleclick_amount(Joystick_button.DPAD_LEFT, value)
var j_doubleclick_amount_value_for_dpad_right: float:
	set(value):
		j_doubleclick_amount_value_for_dpad_right = value
		set_joystick_doubleclick_amount(Joystick_button.DPAD_RIGHT, value)

var j_doubleclick_amount_value_for_all_joystick_buttons: float:
	set(value):
		j_doubleclick_amount_value_for_all_joystick_buttons = value
		set_joystick_doubleclick_amount_globally(value)

var j_motion_radius_for_left_stick_top_right_side: float:
	set(value):
		j_motion_radius_for_left_stick_top_right_side = value
		set_joystick_axis_radius(Joystick_motion.LAXIS, Joystick_motion_radius.TopRight, value)
var j_motion_radius_for_left_stick_bottom_right_side: float:
	set(value):
		j_motion_radius_for_left_stick_bottom_right_side = value
		set_joystick_axis_radius(Joystick_motion.LAXIS, Joystick_motion_radius.BottomRight, value)
var j_motion_radius_for_left_stick_top_left_side: float:
	set(value):
		j_motion_radius_for_left_stick_top_left_side = value
		set_joystick_axis_radius(Joystick_motion.LAXIS, Joystick_motion_radius.TopLeft, value)
var j_motion_radius_for_left_stick_bottom_left_side: float:
	set(value):
		j_motion_radius_for_left_stick_bottom_left_side = value
		set_joystick_axis_radius(Joystick_motion.LAXIS, Joystick_motion_radius.ButtomLeft, value)

var j_motion_radius_for_right_stick_top_right_side: float:
	set(value):
		j_motion_radius_for_right_stick_top_right_side = value
		set_joystick_axis_radius(Joystick_motion.RAXIS, Joystick_motion_radius.TopRight, value)
var j_motion_radius_for_right_stick_bottom_right_side: float:
	set(value):
		j_motion_radius_for_right_stick_bottom_right_side = value
		set_joystick_axis_radius(Joystick_motion.RAXIS, Joystick_motion_radius.BottomRight, value)
var j_motion_radius_for_right_stick_top_left_side: float:
	set(value):
		j_motion_radius_for_right_stick_top_left_side = value
		set_joystick_axis_radius(Joystick_motion.RAXIS, Joystick_motion_radius.TopLeft, value)
var j_motion_radius_for_right_stick_bottom_left_side: float:
	set(value):
		j_motion_radius_for_right_stick_bottom_left_side = value
		set_joystick_axis_radius(Joystick_motion.RAXIS, Joystick_motion_radius.ButtomLeft, value)

var j_motion_radius_for_all_left_stick_sides: float:
	set(value):
		j_motion_radius_for_all_left_stick_sides = value
		set_joystick_axis_radius_globally(Joystick_motion.LAXIS, value)
var j_motion_radius_for_all_right_stick_sides: float:
	set(value):
		j_motion_radius_for_all_right_stick_sides = value
		set_joystick_axis_radius_globally(Joystick_motion.RAXIS, value)

var j_motion_radius_for_all_stick_sides: float:
	set(value):
		j_motion_radius_for_all_stick_sides = value
		set_joystick_axis_radius_globally(Joystick_motion.LAXIS, value)
		set_joystick_axis_radius_globally(Joystick_motion.RAXIS, value)



var config_path: JSON = null

var save_config: bool = false:
	set(value):
		save_config = value
		if save_config == true and is_outside_editor():
			save_config = false
			return
		
		if save_config == true and is_inside_editor():
			
			# [ERROR 1] If there is no config file attached to the property, but is being called for saving
			if config_path == null:
				printerr("ERROR 1 | Cannot save configuration: JSON File is not inserted to Config Path!")
				save_config = false
				return
			
			# [ERROR 2] If the resource path contains the type of text in Resource path that makes it a temporary Object
			# or has no real path to save stuff onto
			if config_path.resource_path.contains("tscn::JSON"):
				printerr("ERROR 2 | Cannot save configuration: The JSON File's Path is not configured properly! Either the File's Resource path is wrong or the File must be saved onto the Project first.")
				save_config = false
				return
			
			# [ERROR 3] If the resource path is not included in the JSON File
			if config_path.resource_path == "":
				printerr("ERROR 3 | Cannot save configuration: The JSON File's Path is empty! Set a proper path to the JSON File's Resource path to fix this issue.")
				save_config = false
				return
			
			# Create a file and access the "config_path" variable. Should be only WRITE in this case.
			var file = FileAccess.open(config_path.resource_path, FileAccess.WRITE)
			
			var data: Dictionary = {
				"type": "VInput",
				"current_device": current_device,
				"default_device": default_device,
				
				"mouse_pressed": mouse_pressed,
				"keyboard_pressed": keyboard_pressed,
				"joystick_pressed": joystick_pressed,
				
				"mouse_active": mouse_active,
				"keyboard_active": keyboard_active,
				"joystick_active": joystick_active,
				
				"mouse_action": mouse_action,
				"mouse_current_doubleclick_time": mouse_current_doubleclick_time,
				"mouse_current_doubleclick_amount": mouse_current_doubleclick_amount,
				"mouse_current_delay": mouse_current_delay,
				"mouse_doubleclick_action": mouse_doubleclick_action,
				"mouse_limit_doubleclick_time": mouse_limit_doubleclick_time,
				"mouse_limit_doubleclick_amount": mouse_limit_doubleclick_amount,
				"mouse_limit_delay": mouse_limit_delay,
				
				"keyboard_action": keyboard_action,
				"keyboard_current_doubleclick_time": keyboard_current_doubleclick_time,
				"keyboard_current_doubleclick_amount": keyboard_current_doubleclick_amount,
				"keyboard_doubleclick_action": keyboard_doubleclick_action,
				"keyboard_limit_doubleclick_time": keyboard_limit_doubleclick_time,
				"keyboard_limit_doubleclick_amount": keyboard_limit_doubleclick_amount,
				
				"joystick_action": joystick_action,
				"joystick_current_doubleclick_time": joystick_current_doubleclick_time,
				"joystick_current_doubleclick_amount": joystick_current_doubleclick_amount,
				"joystick_current_delay": joystick_current_delay,
				"joystick_doubleclick_action": joystick_doubleclick_action,
				"joystick_limit_doubleclick_time": joystick_limit_doubleclick_time,
				"joystick_limit_doubleclick_amount": joystick_limit_doubleclick_amount,
				"joystick_limit_delay": joystick_limit_delay,
				"joystick_motion": joystick_motion,
				"joystick_laxis_radius_topright": joystick_laxis_radius_topright,
				"joystick_laxis_radius_bottomright": joystick_laxis_radius_bottomright,
				"joystick_laxis_radius_bottomleft": joystick_laxis_radius_bottomleft,
				"joystick_laxis_radius_topleft": joystick_laxis_radius_topleft,
				"joystick_raxis_radius_topright": joystick_raxis_radius_topright,
				"joystick_raxis_radius_bottomright": joystick_raxis_radius_bottomright,
				"joystick_raxis_radius_bottomleft": joystick_raxis_radius_bottomleft,
				"joystick_raxis_radius_topleft": joystick_raxis_radius_topleft,
			
				"mouse_delay_choise": m_delay_input_choise,
				"mouse_delay_option": m_delay_input_option,
				"mouse_doubleclick_time_choise": m_doubleclick_time_input_choise,
				"mouse_doubleclick_time_option": m_doubleclick_time_input_option,
				"mouse_doubleclick_amount_choise": m_doubleclick_amount_input_choise,
				"mouse_doubleclick_amount_option": m_doubleclick_amount_input_option,
				
				"keyboard_doubleclick_time_choise": k_doubleclick_time_input_choise,
				"keyboard_doubleclick_time_option": k_doubleclick_time_input_option,
				"keyboard_doubleclick_time_letter_option": k_doubleclick_time_keyboard_letter_option,
				"keyboard_doubleclick_time_number_option": k_doubleclick_time_keyboard_number_option,
				"keyboard_doubleclick_time_f_key_option": k_doubleclick_time_keyboard_f_key_option,
				"keyboard_doubleclick_time_left_special_key_option": k_doubleclick_time_keyboard_left_special_key_option,
				"keyboard_doubleclick_time_arrow_option": k_doubleclick_time_keyboard_arrow_option,
				"keyboard_doubleclick_time_right_special_key_option": k_doubleclick_time_keyboard_right_special_key_option,
				"keyboard_doubleclick_time_numeric_key_option": k_doubleclick_time_keyboard_KP_key_option,
				"keyboard_doubleclick_amount_choise": k_doubleclick_amount_input_choise,
				"keyboard_doubleclick_amount_option": k_doubleclick_amount_input_option,
				"keyboard_doubleclick_amount_letter_option": k_doubleclick_amount_keyboard_letter_option,
				"keyboard_doubleclick_amount_number_option": k_doubleclick_amount_keyboard_number_option,
				"keyboard_doubleclick_amount_f_key_option": k_doubleclick_amount_keyboard_f_key_option,
				"keyboard_doubleclick_amount_left_special_key_option": k_doubleclick_amount_keyboard_left_special_key_option,
				"keyboard_doubleclick_amount_arrow_option": k_doubleclick_amount_keyboard_arrow_option,
				"keyboard_doubleclick_amount_right_special_key_option": k_doubleclick_amount_keyboard_right_special_key_option,
				"keyboard_doubleclick_amount_numeric_key_option": k_doubleclick_amount_keyboard_KP_key_option,
				
				"joystick_delay_choise": j_delay_input_choise,
				"joystick_delay_option": j_delay_input_option,
				"joystick_doubleclick_time_choise": j_doubleclick_time_input_choise,
				"joystick_doubleclick_time_option": j_doubleclick_time_input_option,
				"joystick_doubleclick_amount_choise": j_doubleclick_amount_input_choise,
				"joystick_doubleclick_amount_option": j_doubleclick_amount_input_option,
				"joystick_motion_button_category": j_motion_button_category,
				"joystick_motion_left_stick_option": j_motion_button_left_stick_option,
				"joystick_motion_right_stick_option": j_motion_button_right_stick_option
			}
			
			# Store the values as if it was written, not as an object.
			file.store_string(config_path.stringify(data))
			
			# Close it once it finished storing the Dictionary.
			file.close() 
		
			save_config = false

var load_config: bool = false:
	set(value):
		load_config = value
		if load_config == true and is_outside_editor():
			load_config = false
			return
		
		if load_config == true and is_inside_editor():
			
			# [ERROR 1] If there is no config file attached to the property, but is being called for saving
			if config_path == null:
				printerr("ERROR 1 | Cannot load configuration: JSON File is not inserted to Config Path!")
				load_config = false
				return
			
			# [ERROR 2] If the resource path contains the type of text in Resource path that makes it a temporary Object
			# or has no real path to load stuff onto
			if config_path.resource_path.contains("tscn::JSON"):
				printerr("ERROR 2 | Cannot load configuration: The JSON File's Path is not configured properly! Either the File's Resource path is wrong or the File must be saved onto the Project first.")
				load_config = false
				return
			
			# [ERROR 3] If the resource path is not included in the JSON File
			if config_path.resource_path == "":
				printerr("ERROR 3 | Cannot load configuration: The JSON File's Path is empty! Set a proper path to the JSON File's Resource path to fix this issue.")
				load_config = false
				return
			
			# Create a file and access the "config_path" variable. Should be only WRITE in this case.
			var file = FileAccess.open(config_path.resource_path, FileAccess.READ)
			
			var data: Dictionary = JSON.parse_string(file.get_as_text()) 
			
			for keys in data.keys():
				match keys:
					"type":
						if data.get(keys) != "VInput":
							printerr("ERROR 4 | Cannot load configuration: The JSON File's contexts are not suited for VInput! " +  'The type it was exported to was: "' + str(data.get(keys)) + '". \n Please use a JSON File which is suited for VInput, or save the configuration again for better accuracy.')
							file.close()
							load_config = false
					"current_device": current_device = data.get(keys)
					"default_device": default_device = data.get(keys)
					
					"mouse_pressed": mouse_pressed = data.get(keys)
					"keyboard_pressed": keyboard_pressed = data.get(keys)
					"joystick_pressed": joystick_pressed = data.get(keys)
					
					"mouse_active": mouse_active = data.get(keys)
					"keyboard_active": keyboard_active = data.get(keys)
					"joystick_active": joystick_active = data.get(keys)
					
					"mouse_action": mouse_action = data.get(keys)
					"mouse_current_doubleclick_time": mouse_current_doubleclick_time = data.get(keys)
					"mouse_current_doubleclick_amount": mouse_current_doubleclick_amount = data.get(keys)
					"mouse_current_delay": mouse_current_delay = data.get(keys)
					"mouse_doubleclick_action": mouse_doubleclick_action = data.get(keys)
					"mouse_limit_doubleclick_time": mouse_limit_doubleclick_time = data.get(keys)
					"mouse_limit_doubleclick_amount": mouse_limit_doubleclick_amount = data.get(keys)
					"mouse_limit_delay": mouse_limit_delay = data.get(keys)
					
					"keyboard_action": keyboard_action = data.get(keys)
					"keyboard_current_doubleclick_time": keyboard_current_doubleclick_time = data.get(keys)
					"keyboard_current_doubleclick_amount": keyboard_current_doubleclick_amount = data.get(keys)
					"keyboard_doubleclick_action": keyboard_doubleclick_action = data.get(keys)
					"keyboard_limit_doubleclick_time": keyboard_limit_doubleclick_time = data.get(keys)
					"keyboard_limit_doubleclick_amount": keyboard_limit_doubleclick_amount = data.get(keys)
					
					"joystick_action": joystick_action = data.get(keys)
					"joystick_current_doubleclick_time": joystick_current_doubleclick_time = data.get(keys)
					"joystick_current_doubleclick_amount": joystick_current_doubleclick_amount = data.get(keys)
					"joystick_current_delay": joystick_current_delay = data.get(keys)
					"joystick_doubleclick_action": joystick_doubleclick_action = data.get(keys)
					"joystick_limit_doubleclick_time": joystick_limit_doubleclick_time = data.get(keys)
					"joystick_limit_doubleclick_amount": joystick_limit_doubleclick_amount = data.get(keys)
					"joystick_limit_delay": joystick_limit_delay = data.get(keys)
					"joystick_motion": joystick_motion = data.get(keys)
					"joystick_laxis_radius_topright": joystick_laxis_radius_topright = data.get(keys)
					"joystick_laxis_radius_bottomright": joystick_laxis_radius_bottomright = data.get(keys)
					"joystick_laxis_radius_bottomleft": joystick_laxis_radius_bottomleft = data.get(keys)
					"joystick_laxis_radius_topleft": joystick_laxis_radius_topleft = data.get(keys)
					"joystick_raxis_radius_topright": joystick_raxis_radius_topright = data.get(keys)
					"joystick_raxis_radius_bottomright": joystick_raxis_radius_bottomright = data.get(keys)
					"joystick_raxis_radius_bottomleft": joystick_raxis_radius_bottomleft = data.get(keys)
					"joystick_raxis_radius_topleft": joystick_raxis_radius_topleft = data.get(keys)
				
					"mouse_delay_choise": m_delay_input_choise = data.get(keys)
					"mouse_delay_option": m_delay_input_option = data.get(keys)
					"mouse_doubleclick_time_choise": m_doubleclick_time_input_choise = data.get(keys)
					"mouse_doubleclick_time_option": m_doubleclick_time_input_option = data.get(keys)
					"mouse_doubleclick_amount_choise": m_doubleclick_amount_input_choise = data.get(keys)
					"mouse_doubleclick_amount_option": m_doubleclick_amount_input_option = data.get(keys)
					
					"keyboard_doubleclick_time_choise": k_doubleclick_time_input_choise = data.get(keys)
					"keyboard_doubleclick_time_option": k_doubleclick_time_input_option = data.get(keys)
					"keyboard_doubleclick_time_letter_option": k_doubleclick_time_keyboard_letter_option = data.get(keys)
					"keyboard_doubleclick_time_number_option": k_doubleclick_time_keyboard_number_option = data.get(keys)
					"keyboard_doubleclick_time_f_key_option": k_doubleclick_time_keyboard_f_key_option = data.get(keys)
					"keyboard_doubleclick_time_left_special_key_option": k_doubleclick_time_keyboard_left_special_key_option = data.get(keys)
					"keyboard_doubleclick_time_arrow_option": k_doubleclick_time_keyboard_arrow_option = data.get(keys)
					"keyboard_doubleclick_time_right_special_key_option": k_doubleclick_time_keyboard_right_special_key_option = data.get(keys)
					"keyboard_doubleclick_time_numeric_key_option": k_doubleclick_time_keyboard_KP_key_option = data.get(keys)
					"keyboard_doubleclick_amount_choise": k_doubleclick_amount_input_choise = data.get(keys)
					"keyboard_doubleclick_amount_option": k_doubleclick_amount_input_option = data.get(keys)
					"keyboard_doubleclick_amount_letter_option": k_doubleclick_amount_keyboard_letter_option = data.get(keys)
					"keyboard_doubleclick_amount_number_option": k_doubleclick_amount_keyboard_number_option = data.get(keys)
					"keyboard_doubleclick_amount_f_key_option": k_doubleclick_amount_keyboard_f_key_option = data.get(keys)
					"keyboard_doubleclick_amount_left_special_key_option": k_doubleclick_amount_keyboard_left_special_key_option = data.get(keys)
					"keyboard_doubleclick_amount_arrow_option": k_doubleclick_amount_keyboard_arrow_option = data.get(keys)
					"keyboard_doubleclick_amount_right_special_key_option": k_doubleclick_amount_keyboard_right_special_key_option = data.get(keys)
					"keyboard_doubleclick_amount_numeric_key_option": k_doubleclick_amount_keyboard_KP_key_option = data.get(keys)
					
					"joystick_delay_choise": j_delay_input_choise = data.get(keys)
					"joystick_delay_option": j_delay_input_option = data.get(keys)
					"joystick_doubleclick_time_choise": j_doubleclick_time_input_choise = data.get(keys)
					"joystick_doubleclick_time_option": j_doubleclick_time_input_option = data.get(keys)
					"joystick_doubleclick_amount_choise": j_doubleclick_amount_input_choise = data.get(keys)
					"joystick_doubleclick_amount_option": j_doubleclick_amount_input_option = data.get(keys)
					"joystick_motion_button_category": j_motion_button_category = data.get(keys)
					"joystick_motion_left_stick_option": j_motion_button_left_stick_option = data.get(keys)
					"joystick_motion_right_stick_option": j_motion_button_right_stick_option = data.get(keys)
			
			# Close it once it finished storing the Dictionary.
			file.close() 
			load_config = false

var reset_to_default_settings: bool = false:
	set(value):
		reset_to_default_settings = value
		if reset_to_default_settings == true:
			
			m_delay_input_choise = config_mouse_choise.AllInputs
			m_doubleclick_amount_input_choise = config_mouse_choise.AllInputs
			m_doubleclick_time_input_choise = config_mouse_choise.AllInputs
			m_delay_value_for_all_mouse_inputs = 0.5
			m_doubleclick_amount_value_for_all_mouse_inputs = 2
			m_doubleclick_time_value_for_all_mouse_inputs = 0.75
			
			k_doubleclick_amount_input_choise = config_keyboard_choise.AllInputs
			k_doubleclick_time_input_choise = config_keyboard_choise.AllInputs
			k_doubleclick_amount_value_for_all_keyboard_inputs = 2
			k_doubleclick_time_value_for_all_keyboard_inputs = 0.75
			
			j_delay_input_choise = config_joystick_choise.AllInputs
			j_doubleclick_amount_input_choise = config_joystick_choise.AllInputs
			j_doubleclick_time_input_choise = config_joystick_choise.AllInputs
			j_motion_button_category = config_joystick_motion_category.All_Sticks
			j_delay_value_for_all_joystick_buttons = 0.5
			j_doubleclick_amount_value_for_all_joystick_buttons = 2
			j_doubleclick_time_value_for_all_joystick_buttons = 0.75
			j_motion_radius_for_all_stick_sides = 0.2
			
			reset_to_default_settings = false

func _get_property_list() -> Array:
	var inspector = VInspector.new()
	
	inspector.create_category("VInput")
	inspector.create_json_file("config_path", true)
	
	if config_path == null:
		inspector.create_bool("save_config", false)
		inspector.create_bool("load_config", false)
	if config_path != null:
		inspector.create_bool("save_config", true)
		inspector.create_bool("load_config", true)
	inspector.create_bool("reset_to_default_settings", true)
	inspector.create_bool("working", true)
	
	inspector.create_category("MouseOption")
	
	#Mouse / Delay Group
	inspector.create_group("Mouse Delay", "m_delay_")
	inspector.create_enum("m_delay_input_choise", config_mouse_choise, true, false, true)
	match m_delay_input_choise:
		config_mouse_choise.AllInputs:
			inspector.create_float("m_delay_value_for_all_mouse_inputs", true, 0, 20, 0.01)
		config_mouse_choise.SeparateInputs:
			inspector.create_enum("m_delay_input_option", config_mouse_separate_input_option, true, false, true)
			
			for size in config_mouse_separate_input_option.size():
				if m_delay_input_option == size and m_delay_input_option != config_mouse_separate_input_option.None:
					inspector.create_float("m_delay_value_for_" + str(config_mouse_separate_input_option.find_key(size)).to_lower(), true, 0, 20, 0.01)
					break
	
	# Mouse / Doubleclick Time Group
	inspector.create_group("Mouse Doubleclick Time", "m_doubleclick_time_")
	inspector.create_enum("m_doubleclick_time_input_choise", config_mouse_choise, true, false, true)
	match m_doubleclick_time_input_choise:
		config_mouse_choise.AllInputs:
			inspector.create_float("m_doubleclick_time_value_for_all_mouse_inputs", true, 0, 20, 0.01)
		config_mouse_choise.SeparateInputs:
			inspector.create_enum("m_doubleclick_time_input_option", config_mouse_separate_input_option, true, false, true)
			
			for size in config_mouse_separate_input_option.size():
				if m_doubleclick_time_input_option == size and m_doubleclick_time_input_option != config_mouse_separate_input_option.None:
					inspector.create_float("m_doubleclick_time_value_for_" + str(config_mouse_separate_input_option.find_key(size)).to_lower(), true, 0, 20, 0.01)
					break
	
	# Mouse / Doubleclick Amount Group
	inspector.create_group("Mouse Doubleclick Amount", "m_doubleclick_amount_")
	inspector.create_enum("m_doubleclick_amount_input_choise", config_mouse_choise, true, false, true)
	match m_doubleclick_amount_input_choise:
		config_mouse_choise.AllInputs:
			inspector.create_float("m_doubleclick_amount_value_for_all_mouse_inputs", true, 0, 20, 0.01)
		config_mouse_choise.SeparateInputs:
			inspector.create_enum("m_doubleclick_amount_input_option", config_mouse_separate_input_option, true, false, true)
			
			for size in config_mouse_separate_input_option.size():
				if m_doubleclick_amount_input_option == size and m_doubleclick_amount_input_option != config_mouse_separate_input_option.None:
					inspector.create_float("m_doubleclick_amount_value_for_" + str(config_mouse_separate_input_option.find_key(size)).to_lower(), true, 0, 20, 0.01)
					break
	
	inspector.create_category("KeyboardOption")

	inspector.create_group("Keyboard Doubleclick Time", "k_doubleclick_time_")
	inspector.create_enum("k_doubleclick_time_input_choise", config_keyboard_choise, true, false, true)
	match k_doubleclick_time_input_choise:
		config_keyboard_choise.AllInputs:
			inspector.create_float("k_doubleclick_time_value_for_all_keyboard_inputs", true, 0, 20, 0.01)
		config_keyboard_choise.SeparateInputs:
			inspector.create_enum("k_doubleclick_time_input_option", config_keyboard_separate_option, true, false, true)
			match k_doubleclick_time_input_option:
				config_keyboard_separate_option.Letters:
					inspector.create_enum("k_doubleclick_time_keyboard_letter_option", config_keyboard_letters, true, false, true)
					
					# Easier method on listing the corresponding inspector values onto the inspector.
					for size in config_keyboard_letters.size():
						if k_doubleclick_time_keyboard_letter_option == size and k_doubleclick_time_keyboard_letter_option != config_keyboard_letters.None:
							inspector.create_float("k_doubleclick_time_value_for_button_" + config_keyboard_letters.find_key(size), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.Numbers:
					inspector.create_enum("k_doubleclick_time_keyboard_number_option", config_keyboard_numbers, true, true, true)
					
					# Using "size" inside the for loop to complete the inspector value's name without writing many lines of code.
					for size in config_keyboard_numbers.size():
						if k_doubleclick_time_keyboard_number_option == size and k_doubleclick_time_keyboard_number_option != config_keyboard_numbers.None:
							inspector.create_float("k_doubleclick_time_value_for_button_" + str(size - 1), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.FKeys:
					inspector.create_enum("k_doubleclick_time_keyboard_f_key_option", config_keyboard_F_keys, true, true, false)
					
					# First the corresponding value needed to be transformed into a String, then had to use to_lower() to properly
					# apply the right name of the inspector value.
					for size in config_keyboard_F_keys.size():
						if k_doubleclick_time_keyboard_f_key_option == size and k_doubleclick_time_keyboard_f_key_option != config_keyboard_F_keys.None:
							inspector.create_float("k_doubleclick_time_value_for_" + str(config_keyboard_F_keys.find_key(size)).to_lower(), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.LeftSideSpecialKeys:
					inspector.create_enum("k_doubleclick_time_keyboard_left_special_key_option", config_keyboard_left_special_keys, true, false, true)
					
					# The corresponding value is inbetween the two sides of the identical wording, shouldn't be an issue.
					for size in config_keyboard_left_special_keys.size():
						if k_doubleclick_time_keyboard_left_special_key_option == size and k_doubleclick_time_keyboard_left_special_key_option != config_keyboard_left_special_keys.None:
							inspector.create_float("k_doubleclick_time_value_for_" + str(config_keyboard_left_special_keys.find_key(size)).to_lower() + "_button", true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.Arrows:
					inspector.create_enum("k_doubleclick_time_keyboard_arrow_option", config_keyboard_arrows, true, false, true)
					
					# Same as the other ones above.
					for size in config_keyboard_arrows.size():
						if k_doubleclick_time_keyboard_arrow_option == size and k_doubleclick_time_keyboard_arrow_option != config_keyboard_arrows.None:
							inspector.create_float("k_doubleclick_time_value_for_" + str(config_keyboard_arrows.find_key(size)).to_lower(), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.RightSideSpecialKeys:
					inspector.create_enum("k_doubleclick_time_keyboard_right_special_key_option", config_keyboard_right_special_keys, true, false, true)
					
					# The corresponding value is inbetween the two sides of the identical wording, shouldn't be an issue.
					for size in config_keyboard_right_special_keys.size():
						if k_doubleclick_time_keyboard_right_special_key_option == size and k_doubleclick_time_keyboard_right_special_key_option != config_keyboard_right_special_keys.None:
							inspector.create_float("k_doubleclick_time_value_for_" + str(config_keyboard_right_special_keys.find_key(size)).to_lower() + "_button", true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.NumericPartKeys:
					inspector.create_enum("k_doubleclick_time_keyboard_KP_key_option", config_keyboard_KP_keys, true, true, true)
					
					for size in config_keyboard_KP_keys.size():
						if k_doubleclick_time_keyboard_KP_key_option == size and k_doubleclick_time_keyboard_KP_key_option != config_keyboard_KP_keys.None:
							# There are 2 conditions, where the wording has to be changed, depending on the KP numbers and KP values.
							# The two conditions won't be needed to be checked, so we can call break on both conditions.
							if k_doubleclick_time_keyboard_KP_key_option <= config_keyboard_KP_keys.KP_Number_9:
								inspector.create_float("k_doubleclick_time_value_for_numeric_button_" + str(size - 1), true, 0, 20, 0.01)
								break
							# This one needed a a lot of tweaking in excluding certain letters and corresponsively placing them
							# inbetween the two sides of the identical wording.
							if k_doubleclick_time_keyboard_KP_key_option > config_keyboard_KP_keys.KP_Number_9:
								inspector.create_float("k_doubleclick_time_value_for_" + str(config_keyboard_KP_keys.find_key(size)).to_lower().replace("kp_", "") + "_numeric_button", true, 0, 20, 0.01)
								break
	
	inspector.create_group("Keyboard Doubleclick Amount", "k_doubleclick_amount_")
	inspector.create_enum("k_doubleclick_amount_input_choise", config_keyboard_choise, true, false, true)
	match k_doubleclick_amount_input_choise:
		config_keyboard_choise.AllInputs:
			inspector.create_float("k_doubleclick_amount_value_for_all_keyboard_inputs", true, 0, 20, 0.01)
		config_keyboard_choise.SeparateInputs:
			inspector.create_enum("k_doubleclick_amount_input_option", config_keyboard_separate_option, true, false, true)
			match k_doubleclick_amount_input_option:
				config_keyboard_separate_option.Letters:
					inspector.create_enum("k_doubleclick_amount_keyboard_letter_option", config_keyboard_letters, true, false, true)
					
					# Easier method on listing the corresponding inspector values onto the inspector.
					for size in config_keyboard_letters.size():
						if k_doubleclick_amount_keyboard_letter_option == size and k_doubleclick_amount_keyboard_letter_option != config_keyboard_letters.None:
							inspector.create_float("k_doubleclick_amount_value_for_button_" + config_keyboard_letters.find_key(size), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.Numbers:
					inspector.create_enum("k_doubleclick_amount_keyboard_number_option", config_keyboard_numbers, true, true, true)
					
					# Using "size" inside the for loop to complete the inspector value's name without writing many lines of code.
					for size in config_keyboard_numbers.size():
						if k_doubleclick_amount_keyboard_number_option == size and k_doubleclick_amount_keyboard_number_option != config_keyboard_numbers.None:
							inspector.create_float("k_doubleclick_amount_value_for_button_" + str(size - 1), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.FKeys:
					inspector.create_enum("k_doubleclick_amount_keyboard_f_key_option", config_keyboard_F_keys, true, true, false)
					
					# First the corresponding value needed to be transformed into a String, then had to use to_lower() to properly
					# apply the right name of the inspector value.
					for size in config_keyboard_F_keys.size():
						if k_doubleclick_amount_keyboard_f_key_option == size and k_doubleclick_amount_keyboard_f_key_option != config_keyboard_F_keys.None:
							inspector.create_float("k_doubleclick_amount_value_for_" + str(config_keyboard_F_keys.find_key(size)).to_lower(), true, 0, 20, 0.01)
							break
				
				config_keyboard_separate_option.LeftSideSpecialKeys:
					inspector.create_enum("k_doubleclick_amount_keyboard_left_special_key_option", config_keyboard_left_special_keys, true, false, true)
					
					# The corresponding value is inbetween the two sides of the identical wording, shouldn't be an issue.
					for size in config_keyboard_left_special_keys.size():
						if k_doubleclick_amount_keyboard_left_special_key_option == size and k_doubleclick_amount_keyboard_left_special_key_option != config_keyboard_left_special_keys.None:
							inspector.create_float("k_doubleclick_amount_value_for_" + str(config_keyboard_left_special_keys.find_key(size)).to_lower() + "_button", true, 0, 20, 0.01)
				
				config_keyboard_separate_option.Arrows:
					inspector.create_enum("k_doubleclick_amount_keyboard_arrow_option", config_keyboard_arrows, true, false, true)
					
					# Same as the other ones above.
					for size in config_keyboard_arrows.size():
						if k_doubleclick_amount_keyboard_arrow_option == size and k_doubleclick_amount_keyboard_arrow_option != config_keyboard_arrows.None:
							inspector.create_float("k_doubleclick_amount_value_for_" + str(config_keyboard_arrows.find_key(size)).to_lower(), true, 0, 20, 0.01)
				
				config_keyboard_separate_option.RightSideSpecialKeys:
					inspector.create_enum("k_doubleclick_amount_keyboard_right_special_key_option", config_keyboard_right_special_keys, true, false, true)
					
					# The corresponding value is inbetween the two sides of the identical wording, shouldn't be an issue.
					for size in config_keyboard_right_special_keys.size():
						if k_doubleclick_amount_keyboard_right_special_key_option == size and k_doubleclick_amount_keyboard_right_special_key_option != config_keyboard_right_special_keys.None:
							inspector.create_float("k_doubleclick_amount_value_for_" + str(config_keyboard_right_special_keys.find_key(size)).to_lower() + "_button", true, 0, 20, 0.01)
				
				config_keyboard_separate_option.NumericPartKeys:
					inspector.create_enum("k_doubleclick_amount_keyboard_KP_key_option", config_keyboard_KP_keys, true, true, true)
					
					for size in config_keyboard_KP_keys.size():
						if k_doubleclick_amount_keyboard_KP_key_option == size and k_doubleclick_amount_keyboard_KP_key_option != config_keyboard_KP_keys.None:
							# There are 2 conditions, where the wording has to be changed, depending on the KP numbers and KP values.
							# The two conditions won't be needed to be checked, so we can call break on both conditions.
							if k_doubleclick_amount_keyboard_KP_key_option <= config_keyboard_KP_keys.KP_Number_9:
								inspector.create_float("k_doubleclick_amount_value_for_numeric_button_" + str(size - 1), true, 0, 20, 0.01)
								break
							# This one needed a a lot of tweaking in excluding certain letters and corresponsively placing them
							# inbetween the two sides of the identical wording.
							if k_doubleclick_amount_keyboard_KP_key_option > config_keyboard_KP_keys.KP_Number_9:
								inspector.create_float("k_doubleclick_amount_value_for_" + str(config_keyboard_KP_keys.find_key(size)).to_lower().replace("kp_", "") + "_numeric_button", true, 0, 20, 0.01)
								break
	
	inspector.create_category("JoystickOption")
	
	inspector.create_group("Joystick Delay", "j_delay_")
	inspector.create_enum("j_delay_input_choise", config_joystick_choise, true, false, true)
	match j_delay_input_choise:
		config_joystick_choise.AllInputs:
			inspector.create_float("j_delay_value_for_all_joystick_buttons", true, 0, 20, 0.01)
		config_joystick_choise.SeparateInputs:
			inspector.create_enum("j_delay_input_option", config_joystick_input_option, true, false, true)
			
			for size in config_joystick_input_option.size():
				if j_delay_input_option == size and j_delay_input_option != config_joystick_input_option.None:
					inspector.create_float("j_delay_value_for_" + str(config_joystick_input_option.find_key(size)).to_lower(), true, 0, 20, 0.01)
					break
	
	inspector.create_group("Joystick Doubleclick Time", "j_doubleclick_time_")
	inspector.create_enum("j_doubleclick_time_input_choise", config_joystick_choise, true, false, true)
	match j_doubleclick_time_input_choise:
		config_joystick_choise.AllInputs:
			inspector.create_float("j_doubleclick_time_value_for_all_joystick_buttons", true, 0, 20, 0.01)
		config_joystick_choise.SeparateInputs:
			inspector.create_enum("j_doubleclick_time_input_option", config_joystick_input_option, true, false, true)
			
			for size in config_joystick_input_option.size():
				if j_doubleclick_time_input_option == size and j_doubleclick_time_input_option != config_joystick_input_option.None:
					inspector.create_float("j_doubleclick_time_value_for_" + str(config_joystick_input_option.find_key(size)).to_lower(), true, 0, 20, 0.01)
					break
	
	inspector.create_group("Joystick Doubleclick Amount", "j_doubleclick_amount_")
	inspector.create_enum("j_doubleclick_amount_input_choise", config_joystick_choise, true, false, true)
	match j_doubleclick_amount_input_choise:
		config_joystick_choise.AllInputs:
			inspector.create_float("j_doubleclick_amount_value_for_all_joystick_buttons", true, 0, 20, 0.01)
		config_joystick_choise.SeparateInputs:
			inspector.create_enum("j_doubleclick_amount_input_option", config_joystick_input_option, true, false, true)
			
			for size in config_joystick_input_option.size():
				if j_doubleclick_amount_input_option == size and j_doubleclick_amount_input_option != config_joystick_input_option.None:
					inspector.create_float("j_doubleclick_amount_value_for_" + str(config_joystick_input_option.find_key(size)).to_lower(), true, 0, 20, 0.01)
					break
	
	inspector.create_group("Joystick Motion Change", "j_motion_")
	inspector.create_enum("j_motion_button_category", config_joystick_motion_category, true, false, true)
	match j_motion_button_category:
		config_joystick_motion_category.All_Sticks:
			inspector.create_float("j_motion_radius_for_all_stick_sides", true, 0, 1, 0.01)
		config_joystick_motion_category.Left_Stick:
			inspector.create_enum("j_motion_button_left_stick_option", config_joystick_motion_left_stick_option, true, false, true)
			
			for size in config_joystick_motion_left_stick_option.size():
				if j_motion_button_left_stick_option == size and j_motion_button_left_stick_option != config_joystick_motion_left_stick_option.None:
					inspector.create_float("j_motion_radius_for_" + str(config_joystick_motion_category.find_key(1)).to_lower() + "_" + str(config_joystick_motion_left_stick_option.find_key(size)).to_lower(), true, 0, 1, 0.01)
		
		config_joystick_motion_category.Right_Stick:
			inspector.create_enum("j_motion_button_right_stick_option", config_joystick_motion_right_stick_option, true, false, true)
			
			for size in config_joystick_motion_right_stick_option.size():
				if j_motion_button_right_stick_option == size and j_motion_button_right_stick_option != config_joystick_motion_right_stick_option.None:
					inspector.create_float("j_motion_radius_for_" + str(config_joystick_motion_category.find_key(2)).to_lower() + "_" + str(config_joystick_motion_right_stick_option.find_key(size)).to_lower(), true, 0, 1, 0.01)
		
	
	return inspector.properties


func apply_input_pressed(delta):
	var mouse_array = [Input.is_action_pressed("Left Mouse Button"),Input.is_action_pressed("Right Mouse Button"),Input.is_action_pressed("Middle Mouse Button"),Input.is_action_just_released("Mouse Wheel Up Trigger"),Input.is_action_just_released("Mouse Wheel Down Trigger"),Input.is_action_just_released("Mouse Wheel Left Trigger"),Input.is_action_just_released("Mouse Wheel Right Trigger"),Input.is_action_pressed("Mouse Special Button 1"),Input.is_action_pressed("Mouse Special Button 2")]
	var mouse_motion_var = Input.get_last_mouse_velocity()
	var joystick_array = [Input.is_action_pressed("Joystick (A)"),Input.is_action_pressed("Joystick (B)"),Input.is_action_pressed("Joystick (X)"),Input.is_action_pressed("Joystick (Y)"),Input.is_action_pressed("Joystick Left Bumper"),Input.is_action_pressed("Joystick Right Bumper"),Input.is_action_pressed("Joystick Left Trigger"),Input.is_action_pressed("Joystick Right Trigger"),Input.is_action_pressed("Joystick Start Button"),Input.is_action_pressed("Joystick Back Button"),Input.is_action_pressed("Joystick Connection Button"),Input.is_action_pressed("Joystick Left Stick Button"),Input.is_action_pressed("Joystick Right Stick Button"),Input.is_action_pressed("Joystick DPAD Up"),Input.is_action_pressed("Joystick DPAD Down"),Input.is_action_pressed("Joystick DPAD Left"),Input.is_action_pressed("Joystick DPAD Right"),Input.is_action_pressed("Joystick Left Stick Up"),Input.is_action_pressed("Joystick Left Stick Down"),Input.is_action_pressed("Joystick Left Stick Left"),Input.is_action_pressed("Joystick Left Stick Right"),Input.is_action_pressed("Joystick Right Stick Up"),Input.is_action_pressed("Joystick Right Stick Down"),Input.is_action_pressed("Joystick Right Stick Left"),Input.is_action_pressed("Joystick Right Stick Right")]
	var joystick_motion_array = [Input.get_action_raw_strength("Joystick Left Trigger"), Input.get_action_raw_strength("Joystick Right Trigger"), Input.get_action_raw_strength("Joystick Left Stick Up"), Input.get_action_raw_strength("Joystick Left Stick Down"), Input.get_action_raw_strength("Joystick Left Stick Left"), Input.get_action_raw_strength("Joystick Left Stick Right"), Input.get_action_raw_strength("Joystick Right Stick Up"), Input.get_action_raw_strength("Joystick Right Stick Down"), Input.get_action_raw_strength("Joystick Right Stick Left"), Input.get_action_raw_strength("Joystick Right Stick Right"), Vector2(Input.get_action_raw_strength("Joystick Left Stick Right") - Input.get_action_raw_strength("Joystick Left Stick Left"), Input.get_action_raw_strength("Joystick Left Stick Up") - Input.get_action_raw_strength("Joystick Left Stick Down")), Vector2(Input.get_action_raw_strength("Joystick Right Stick Right") - Input.get_action_raw_strength("Joystick Right Stick Left"), Input.get_action_raw_strength("Joystick Right Stick Up") - Input.get_action_raw_strength("Joystick Right Stick Down"))]
	var keyboard_array = [Input.is_key_pressed(KEY_NONE),Input.is_key_pressed(KEY_SPECIAL),Input.is_key_pressed(KEY_ESCAPE),Input.is_key_pressed(KEY_TAB),Input.is_key_pressed(KEY_BACKTAB),Input.is_key_pressed(KEY_BACKSPACE),Input.is_key_pressed(KEY_ENTER),Input.is_key_pressed(KEY_KP_ENTER),Input.is_key_pressed(KEY_INSERT),Input.is_key_pressed(KEY_DELETE),Input.is_key_pressed(KEY_PAUSE),Input.is_key_pressed(KEY_PRINT),Input.is_key_pressed(KEY_SYSREQ),Input.is_key_pressed(KEY_CLEAR),Input.is_key_pressed(KEY_HOME),Input.is_key_pressed(KEY_END),Input.is_key_pressed(KEY_LEFT),Input.is_key_pressed(KEY_UP),Input.is_key_pressed(KEY_RIGHT),Input.is_key_pressed(KEY_DOWN),Input.is_key_pressed(KEY_PAGEUP),Input.is_key_pressed(KEY_PAGEDOWN),Input.is_key_pressed(KEY_SHIFT),Input.is_key_pressed(KEY_CTRL),Input.is_key_pressed(KEY_META),Input.is_key_pressed(KEY_ALT), Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_ALT), Input.is_key_pressed(KEY_CAPSLOCK),Input.is_key_pressed(KEY_NUMLOCK),Input.is_key_pressed(KEY_SCROLLLOCK),Input.is_key_pressed(KEY_F1),Input.is_key_pressed(KEY_F2),Input.is_key_pressed(KEY_F3),Input.is_key_pressed(KEY_F4),Input.is_key_pressed(KEY_F5),Input.is_key_pressed(KEY_F6),Input.is_key_pressed(KEY_F7),Input.is_key_pressed(KEY_F8),Input.is_key_pressed(KEY_F9),Input.is_key_pressed(KEY_F10),Input.is_key_pressed(KEY_F11),Input.is_key_pressed(KEY_F12),Input.is_key_pressed(KEY_F13),Input.is_key_pressed(KEY_F14),Input.is_key_pressed(KEY_F15),Input.is_key_pressed(KEY_F16),Input.is_key_pressed(KEY_F17),Input.is_key_pressed(KEY_F18),Input.is_key_pressed(KEY_F19),Input.is_key_pressed(KEY_F20),Input.is_key_pressed(KEY_F21),Input.is_key_pressed(KEY_F22),Input.is_key_pressed(KEY_F23),Input.is_key_pressed(KEY_F24),Input.is_key_pressed(KEY_F25),Input.is_key_pressed(KEY_F26),Input.is_key_pressed(KEY_F27),Input.is_key_pressed(KEY_F28),Input.is_key_pressed(KEY_F29),Input.is_key_pressed(KEY_F30),Input.is_key_pressed(KEY_F31),Input.is_key_pressed(KEY_F32),Input.is_key_pressed(KEY_F33),Input.is_key_pressed(KEY_F34),Input.is_key_pressed(KEY_F35),Input.is_key_pressed(KEY_KP_MULTIPLY),Input.is_key_pressed(KEY_KP_DIVIDE),Input.is_key_pressed(KEY_KP_SUBTRACT),Input.is_key_pressed(KEY_KP_PERIOD),Input.is_key_pressed(KEY_KP_ADD),Input.is_key_pressed(KEY_KP_0),Input.is_key_pressed(KEY_KP_1),Input.is_key_pressed(KEY_KP_2),Input.is_key_pressed(KEY_KP_3),Input.is_key_pressed(KEY_KP_4),Input.is_key_pressed(KEY_KP_5),Input.is_key_pressed(KEY_KP_6),Input.is_key_pressed(KEY_KP_7),Input.is_key_pressed(KEY_KP_8),Input.is_key_pressed(KEY_KP_9),Input.is_key_pressed(KEY_MENU),Input.is_key_pressed(KEY_HYPER),Input.is_key_pressed(KEY_HELP),Input.is_key_pressed(KEY_BACK),Input.is_key_pressed(KEY_FORWARD),Input.is_key_pressed(KEY_STOP),Input.is_key_pressed(KEY_REFRESH),Input.is_key_pressed(KEY_VOLUMEDOWN),Input.is_key_pressed(KEY_VOLUMEMUTE),Input.is_key_pressed(KEY_VOLUMEUP),Input.is_key_pressed(KEY_MEDIAPLAY),Input.is_key_pressed(KEY_MEDIASTOP),Input.is_key_pressed(KEY_MEDIAPREVIOUS),Input.is_key_pressed(KEY_MEDIANEXT),Input.is_key_pressed(KEY_MEDIARECORD),Input.is_key_pressed(KEY_HOMEPAGE),Input.is_key_pressed(KEY_FAVORITES),Input.is_key_pressed(KEY_SEARCH),Input.is_key_pressed(KEY_STANDBY),Input.is_key_pressed(KEY_OPENURL),Input.is_key_pressed(KEY_LAUNCHMAIL),Input.is_key_pressed(KEY_LAUNCHMEDIA),Input.is_key_pressed(KEY_LAUNCH0),Input.is_key_pressed(KEY_LAUNCH1),Input.is_key_pressed(KEY_LAUNCH2),Input.is_key_pressed(KEY_LAUNCH3),Input.is_key_pressed(KEY_LAUNCH4),Input.is_key_pressed(KEY_LAUNCH5),Input.is_key_pressed(KEY_LAUNCH6),Input.is_key_pressed(KEY_LAUNCH7),Input.is_key_pressed(KEY_LAUNCH8),Input.is_key_pressed(KEY_LAUNCH9),Input.is_key_pressed(KEY_LAUNCHA),Input.is_key_pressed(KEY_LAUNCHB),Input.is_key_pressed(KEY_LAUNCHC),Input.is_key_pressed(KEY_LAUNCHD),Input.is_key_pressed(KEY_LAUNCHE),Input.is_key_pressed(KEY_LAUNCHF),Input.is_key_pressed(KEY_UNKNOWN),Input.is_key_pressed(KEY_SPACE),Input.is_key_pressed(KEY_EXCLAM),Input.is_key_pressed(KEY_QUOTEDBL),Input.is_key_pressed(KEY_NUMBERSIGN),Input.is_key_pressed(KEY_DOLLAR),Input.is_key_pressed(KEY_PERCENT),Input.is_key_pressed(KEY_AMPERSAND),Input.is_key_pressed(KEY_APOSTROPHE),Input.is_key_pressed(KEY_PARENLEFT),Input.is_key_pressed(KEY_PARENRIGHT),Input.is_key_pressed(KEY_ASTERISK),Input.is_key_pressed(KEY_PLUS),Input.is_key_pressed(KEY_COMMA),Input.is_key_pressed(KEY_MINUS),Input.is_key_pressed(KEY_PERIOD),Input.is_key_pressed(KEY_SLASH),Input.is_key_pressed(KEY_0),Input.is_key_pressed(KEY_1),Input.is_key_pressed(KEY_2),Input.is_key_pressed(KEY_3),Input.is_key_pressed(KEY_4),Input.is_key_pressed(KEY_5),Input.is_key_pressed(KEY_6),Input.is_key_pressed(KEY_7),Input.is_key_pressed(KEY_8),Input.is_key_pressed(KEY_9),Input.is_key_pressed(KEY_COLON),Input.is_key_pressed(KEY_SEMICOLON),Input.is_key_pressed(KEY_LESS),Input.is_key_pressed(KEY_EQUAL),Input.is_key_pressed(KEY_GREATER),Input.is_key_pressed(KEY_QUESTION),Input.is_key_pressed(KEY_AT),Input.is_key_pressed(KEY_A),Input.is_key_pressed(KEY_B),Input.is_key_pressed(KEY_C),Input.is_key_pressed(KEY_D),Input.is_key_pressed(KEY_E),Input.is_key_pressed(KEY_F),Input.is_key_pressed(KEY_G),Input.is_key_pressed(KEY_H),Input.is_key_pressed(KEY_I),Input.is_key_pressed(KEY_J),Input.is_key_pressed(KEY_K),Input.is_key_pressed(KEY_L),Input.is_key_pressed(KEY_M),Input.is_key_pressed(KEY_N),Input.is_key_pressed(KEY_O),Input.is_key_pressed(KEY_P),Input.is_key_pressed(KEY_Q),Input.is_key_pressed(KEY_R),Input.is_key_pressed(KEY_S),Input.is_key_pressed(KEY_T),Input.is_key_pressed(KEY_U),Input.is_key_pressed(KEY_V),Input.is_key_pressed(KEY_W),Input.is_key_pressed(KEY_X),Input.is_key_pressed(KEY_Y),Input.is_key_pressed(KEY_Z),Input.is_key_pressed(KEY_BRACKETLEFT),Input.is_key_pressed(KEY_BACKSLASH),Input.is_key_pressed(KEY_BRACKETRIGHT),Input.is_key_pressed(KEY_ASCIICIRCUM),Input.is_key_pressed(KEY_UNDERSCORE),Input.is_key_pressed(KEY_QUOTELEFT),Input.is_key_pressed(KEY_BRACELEFT),Input.is_key_pressed(KEY_BAR),Input.is_key_pressed(KEY_BRACERIGHT),Input.is_key_pressed(KEY_ASCIITILDE),Input.is_key_pressed(KEY_YEN),Input.is_key_pressed(KEY_SECTION),Input.is_key_pressed(KEY_GLOBE),Input.is_key_pressed(KEY_KEYBOARD),Input.is_key_pressed(KEY_JIS_EISU),Input.is_key_pressed(KEY_JIS_KANA)]
	
	if joystick_pressed != joystick_array:
		joystick_pressed = joystick_array
		current_device = Device.Joystick
	
	if joystick_motion != joystick_motion_array:
		joystick_motion = joystick_motion_array
		current_device = Device.Joystick
	
	if keyboard_pressed != keyboard_array:
		keyboard_pressed = keyboard_array
		current_device = Device.Keyboard
	
	if mouse_pressed != mouse_array:
		mouse_pressed = mouse_array
		current_device = Device.Mouse
	
	if mouse_motion != mouse_motion_var:
		mouse_motion = mouse_motion_var
		current_device = Device.Mouse

func set_mouse_values():
	mouse_pressed = [Input.is_action_pressed("Left Mouse Button"),Input.is_action_pressed("Right Mouse Button"),Input.is_action_pressed("Middle Mouse Button"),Input.is_action_just_released("Mouse Wheel Up Trigger"),Input.is_action_just_released("Mouse Wheel Down Trigger"),Input.is_action_just_released("Mouse Wheel Left Trigger"),Input.is_action_just_released("Mouse Wheel Right Trigger"),Input.is_action_pressed("Mouse Special Button 1"),Input.is_action_pressed("Mouse Special Button 2")]
	mouse_current_doubleclick_time.fill(0.0)
	mouse_current_doubleclick_amount.fill(0)
	mouse_doubleclick_action.fill(DoubleclickAction.False)
	mouse_current_delay.fill(0.0)
	mouse_action.fill(Action.Released)
	mouse_motion = Input.get_last_mouse_velocity()
func set_keyboard_values():
	keyboard_pressed = [Input.is_key_pressed(KEY_NONE),Input.is_key_pressed(KEY_SPECIAL),Input.is_key_pressed(KEY_ESCAPE),Input.is_key_pressed(KEY_TAB),Input.is_key_pressed(KEY_BACKTAB),Input.is_key_pressed(KEY_BACKSPACE),Input.is_key_pressed(KEY_ENTER),Input.is_key_pressed(KEY_KP_ENTER),Input.is_key_pressed(KEY_INSERT),Input.is_key_pressed(KEY_DELETE),Input.is_key_pressed(KEY_PAUSE),Input.is_key_pressed(KEY_PRINT),Input.is_key_pressed(KEY_SYSREQ),Input.is_key_pressed(KEY_CLEAR),Input.is_key_pressed(KEY_HOME),Input.is_key_pressed(KEY_END),Input.is_key_pressed(KEY_LEFT),Input.is_key_pressed(KEY_UP),Input.is_key_pressed(KEY_RIGHT),Input.is_key_pressed(KEY_DOWN),Input.is_key_pressed(KEY_PAGEUP),Input.is_key_pressed(KEY_PAGEDOWN),Input.is_key_pressed(KEY_SHIFT),Input.is_key_pressed(KEY_CTRL),Input.is_key_pressed(KEY_META),Input.is_key_pressed(KEY_ALT),Input.is_key_pressed(KEY_CTRL) and Input.is_key_pressed(KEY_ALT),Input.is_key_pressed(KEY_CAPSLOCK),Input.is_key_pressed(KEY_NUMLOCK),Input.is_key_pressed(KEY_SCROLLLOCK),Input.is_key_pressed(KEY_F1),Input.is_key_pressed(KEY_F2),Input.is_key_pressed(KEY_F3),Input.is_key_pressed(KEY_F4),Input.is_key_pressed(KEY_F5),Input.is_key_pressed(KEY_F6),Input.is_key_pressed(KEY_F7),Input.is_key_pressed(KEY_F8),Input.is_key_pressed(KEY_F9),Input.is_key_pressed(KEY_F10),Input.is_key_pressed(KEY_F11),Input.is_key_pressed(KEY_F12),Input.is_key_pressed(KEY_F13),Input.is_key_pressed(KEY_F14),Input.is_key_pressed(KEY_F15),Input.is_key_pressed(KEY_F16),Input.is_key_pressed(KEY_F17),Input.is_key_pressed(KEY_F18),Input.is_key_pressed(KEY_F19),Input.is_key_pressed(KEY_F20),Input.is_key_pressed(KEY_F21),Input.is_key_pressed(KEY_F22),Input.is_key_pressed(KEY_F23),Input.is_key_pressed(KEY_F24),Input.is_key_pressed(KEY_F25),Input.is_key_pressed(KEY_F26),Input.is_key_pressed(KEY_F27),Input.is_key_pressed(KEY_F28),Input.is_key_pressed(KEY_F29),Input.is_key_pressed(KEY_F30),Input.is_key_pressed(KEY_F31),Input.is_key_pressed(KEY_F32),Input.is_key_pressed(KEY_F33),Input.is_key_pressed(KEY_F34),Input.is_key_pressed(KEY_F35),Input.is_key_pressed(KEY_KP_MULTIPLY),Input.is_key_pressed(KEY_KP_DIVIDE),Input.is_key_pressed(KEY_KP_SUBTRACT),Input.is_key_pressed(KEY_KP_PERIOD),Input.is_key_pressed(KEY_KP_ADD),Input.is_key_pressed(KEY_KP_0),Input.is_key_pressed(KEY_KP_1),Input.is_key_pressed(KEY_KP_2),Input.is_key_pressed(KEY_KP_3),Input.is_key_pressed(KEY_KP_4),Input.is_key_pressed(KEY_KP_5),Input.is_key_pressed(KEY_KP_6),Input.is_key_pressed(KEY_KP_7),Input.is_key_pressed(KEY_KP_8),Input.is_key_pressed(KEY_KP_9),Input.is_key_pressed(KEY_MENU),Input.is_key_pressed(KEY_HYPER),Input.is_key_pressed(KEY_HELP),Input.is_key_pressed(KEY_BACK),Input.is_key_pressed(KEY_FORWARD),Input.is_key_pressed(KEY_STOP),Input.is_key_pressed(KEY_REFRESH),Input.is_key_pressed(KEY_VOLUMEDOWN),Input.is_key_pressed(KEY_VOLUMEMUTE),Input.is_key_pressed(KEY_VOLUMEUP),Input.is_key_pressed(KEY_MEDIAPLAY),Input.is_key_pressed(KEY_MEDIASTOP),Input.is_key_pressed(KEY_MEDIAPREVIOUS),Input.is_key_pressed(KEY_MEDIANEXT),Input.is_key_pressed(KEY_MEDIARECORD),Input.is_key_pressed(KEY_HOMEPAGE),Input.is_key_pressed(KEY_FAVORITES),Input.is_key_pressed(KEY_SEARCH),Input.is_key_pressed(KEY_STANDBY),Input.is_key_pressed(KEY_OPENURL),Input.is_key_pressed(KEY_LAUNCHMAIL),Input.is_key_pressed(KEY_LAUNCHMEDIA),Input.is_key_pressed(KEY_LAUNCH0),Input.is_key_pressed(KEY_LAUNCH1),Input.is_key_pressed(KEY_LAUNCH2),Input.is_key_pressed(KEY_LAUNCH3),Input.is_key_pressed(KEY_LAUNCH4),Input.is_key_pressed(KEY_LAUNCH5),Input.is_key_pressed(KEY_LAUNCH6),Input.is_key_pressed(KEY_LAUNCH7),Input.is_key_pressed(KEY_LAUNCH8),Input.is_key_pressed(KEY_LAUNCH9),Input.is_key_pressed(KEY_LAUNCHA),Input.is_key_pressed(KEY_LAUNCHB),Input.is_key_pressed(KEY_LAUNCHC),Input.is_key_pressed(KEY_LAUNCHD),Input.is_key_pressed(KEY_LAUNCHE),Input.is_key_pressed(KEY_LAUNCHF),Input.is_key_pressed(KEY_UNKNOWN),Input.is_key_pressed(KEY_SPACE),Input.is_key_pressed(KEY_EXCLAM),Input.is_key_pressed(KEY_QUOTEDBL),Input.is_key_pressed(KEY_NUMBERSIGN),Input.is_key_pressed(KEY_DOLLAR),Input.is_key_pressed(KEY_PERCENT),Input.is_key_pressed(KEY_AMPERSAND),Input.is_key_pressed(KEY_APOSTROPHE),Input.is_key_pressed(KEY_PARENLEFT),Input.is_key_pressed(KEY_PARENRIGHT),Input.is_key_pressed(KEY_ASTERISK),Input.is_key_pressed(KEY_PLUS),Input.is_key_pressed(KEY_COMMA),Input.is_key_pressed(KEY_MINUS),Input.is_key_pressed(KEY_PERIOD),Input.is_key_pressed(KEY_SLASH),Input.is_key_pressed(KEY_0),Input.is_key_pressed(KEY_1),Input.is_key_pressed(KEY_2),Input.is_key_pressed(KEY_3),Input.is_key_pressed(KEY_4),Input.is_key_pressed(KEY_5),Input.is_key_pressed(KEY_6),Input.is_key_pressed(KEY_7),Input.is_key_pressed(KEY_8),Input.is_key_pressed(KEY_9),Input.is_key_pressed(KEY_COLON),Input.is_key_pressed(KEY_SEMICOLON),Input.is_key_pressed(KEY_LESS),Input.is_key_pressed(KEY_EQUAL),Input.is_key_pressed(KEY_GREATER),Input.is_key_pressed(KEY_QUESTION),Input.is_key_pressed(KEY_AT),Input.is_key_pressed(KEY_A),Input.is_key_pressed(KEY_B),Input.is_key_pressed(KEY_C),Input.is_key_pressed(KEY_D),Input.is_key_pressed(KEY_E),Input.is_key_pressed(KEY_F),Input.is_key_pressed(KEY_G),Input.is_key_pressed(KEY_H),Input.is_key_pressed(KEY_I),Input.is_key_pressed(KEY_J),Input.is_key_pressed(KEY_K),Input.is_key_pressed(KEY_L),Input.is_key_pressed(KEY_M),Input.is_key_pressed(KEY_N),Input.is_key_pressed(KEY_O),Input.is_key_pressed(KEY_P),Input.is_key_pressed(KEY_Q),Input.is_key_pressed(KEY_R),Input.is_key_pressed(KEY_S),Input.is_key_pressed(KEY_T),Input.is_key_pressed(KEY_U),Input.is_key_pressed(KEY_V),Input.is_key_pressed(KEY_W),Input.is_key_pressed(KEY_X),Input.is_key_pressed(KEY_Y),Input.is_key_pressed(KEY_Z),Input.is_key_pressed(KEY_BRACKETLEFT),Input.is_key_pressed(KEY_BACKSLASH),Input.is_key_pressed(KEY_BRACKETRIGHT),Input.is_key_pressed(KEY_ASCIICIRCUM),Input.is_key_pressed(KEY_UNDERSCORE),Input.is_key_pressed(KEY_QUOTELEFT),Input.is_key_pressed(KEY_BRACELEFT),Input.is_key_pressed(KEY_BAR),Input.is_key_pressed(KEY_BRACERIGHT),Input.is_key_pressed(KEY_ASCIITILDE),Input.is_key_pressed(KEY_YEN),Input.is_key_pressed(KEY_SECTION),Input.is_key_pressed(KEY_GLOBE),Input.is_key_pressed(KEY_KEYBOARD),Input.is_key_pressed(KEY_JIS_EISU),Input.is_key_pressed(KEY_JIS_KANA)]
	keyboard_current_doubleclick_time.fill(0.0)
	keyboard_current_doubleclick_amount.fill(0)
	keyboard_doubleclick_action.fill(DoubleclickAction.False)
	keyboard_action.fill(KeyboardAction.Released)
func set_joystick_values():
	joystick_pressed = [Input.is_action_pressed("Joystick (A)"),Input.is_action_pressed("Joystick (B)"),Input.is_action_pressed("Joystick (X)"),Input.is_action_pressed("Joystick (Y)"),Input.is_action_pressed("Joystick Left Bumper"),Input.is_action_pressed("Joystick Right Bumper"),Input.is_action_pressed("Joystick Left Trigger"),Input.is_action_pressed("Joystick Right Trigger"),Input.is_action_pressed("Joystick Start Button"),Input.is_action_pressed("Joystick Back Button"),Input.is_action_pressed("Joystick Connection Button"),Input.is_action_pressed("Joystick Left Stick Button"),Input.is_action_pressed("Joystick Right Stick Button"),Input.is_action_pressed("Joystick DPAD Up"),Input.is_action_pressed("Joystick DPAD Down"),Input.is_action_pressed("Joystick DPAD Left"),Input.is_action_pressed("Joystick DPAD Right"),Input.is_action_pressed("Joystick Left Stick Up"),Input.is_action_pressed("Joystick Left Stick Down"),Input.is_action_pressed("Joystick Left Stick Left"),Input.is_action_pressed("Joystick Left Stick Right"),Input.is_action_pressed("Joystick Right Stick Up"),Input.is_action_pressed("Joystick Right Stick Down"),Input.is_action_pressed("Joystick Right Stick Left"),Input.is_action_pressed("Joystick Right Stick Right")]
	joystick_motion = [Input.get_action_raw_strength("Joystick Left Trigger"), Input.get_action_raw_strength("Joystick Right Trigger"), Input.get_action_raw_strength("Joystick Left Stick Up"), Input.get_action_raw_strength("Joystick Left Stick Down"), Input.get_action_raw_strength("Joystick Left Stick Left"), Input.get_action_raw_strength("Joystick Left Stick Right"), Input.get_action_raw_strength("Joystick Right Stick Up"), Input.get_action_raw_strength("Joystick Right Stick Down"), Input.get_action_raw_strength("Joystick Right Stick Left"), Input.get_action_raw_strength("Joystick Right Stick Right"), Vector2(Input.get_action_raw_strength("Joystick Left Stick Right") - Input.get_action_raw_strength("Joystick Left Stick Left"), Input.get_action_raw_strength("Joystick Left Stick Up") - Input.get_action_raw_strength("Joystick Left Stick Down")), Vector2(Input.get_action_raw_strength("Joystick Right Stick Right") - Input.get_action_raw_strength("Joystick Right Stick Left"), Input.get_action_raw_strength("Joystick Right Stick Up") - Input.get_action_raw_strength("Joystick Right Stick Down"))]
	joystick_current_doubleclick_time.fill(0.0)
	joystick_current_doubleclick_amount.fill(0)
	joystick_doubleclick_action.fill(DoubleclickAction.False)
	joystick_current_delay.fill(0.0)
	joystick_action.fill(Action.Released)

func _ready():
	set_mouse_delay_globally(1)
	set_mouse_doubleclick_time_globally(2)
	set_mouse_doubleclick_amount_globally(2)
	
	set_keyboard_doubleclick_globally(2, 2)
	
	set_joystick_delay_globally(0.25)
	set_joystick_doubleclick_time_globally(1)
	set_joystick_doubleclick_amount_globally(2)
	set_joystick_axis_radius_globally(Joystick_motion.LAXIS, 0.3)
	
	
	
	current_device = default_device

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
func any_mouse_button_just_pressed():
	var result: bool
	for position in Mouse_button.size():
		if mouse_action[position] == Action.JustPressed:
			result = true
			break
	return result
func any_mouse_button_pressed():
	var result: bool
	for position in Mouse_button.size():
		if mouse_action[position] == Action.Pressed:
			result = true
			break
	return result
func any_mouse_button_just_held():
	var result: bool
	for position in Mouse_button.size():
		if mouse_action[position] == Action.JustHeld:
			result = true
			break
	return result
func any_mouse_button_held():
	var result: bool
	for position in Mouse_button.size():
		if mouse_action[position] == Action.Held:
			result = true
			break
	return result
func any_mouse_button_just_released():
	var result: bool
	for position in Mouse_button.size():
		if mouse_action[position] == Action.JustReleased:
			result = true
			break
	return result
func any_mouse_button_released():
	var result: bool
	for position in Mouse_button.size():
		if mouse_action[position] == Action.Released:
			result = true
			break
	return result

func set_mouse_delay_globally(time: float):
	mouse_limit_delay.fill(time)
func set_mouse_delay(button: Mouse_button, time: float):
	mouse_limit_delay[button] = time
func set_mouse_doubleclick_time(button: Mouse_button, time: int):
	mouse_limit_doubleclick_time[button] = time
func set_mouse_doubleclick_amount(button: Mouse_button, amount: int):
	mouse_limit_doubleclick_amount[button] = amount
func set_mouse_doubleclick_time_globally(time: int):
	mouse_limit_doubleclick_time.fill(time)
func set_mouse_doubleclick_amount_globally(amount: int):
	mouse_limit_doubleclick_amount.fill(amount)

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
func get_mouse_current_presses() -> Array:
	var calc: Array = []
	for position in Mouse_button.keys().size():
		if mouse_pressed[position] == true:
			calc.append(Mouse_button.find_key(position))
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
func any_keyboard_button_just_pressed():
	var result: bool
	for position in Keyboard_button.size():
		if keyboard_action[position] == KeyboardAction.JustPressed:
			result = true
			break
	return result
func any_keyboard_button_pressed():
	var result: bool
	for position in Keyboard_button.size():
		if keyboard_action[position] == KeyboardAction.Pressed:
			result = true
			break
	return result
func any_keyboard_button_just_released():
	var result: bool
	for position in Keyboard_button.size():
		if keyboard_action[position] == KeyboardAction.JustReleased:
			result = true
			break
	return result
func any_keyboard_button_released():
	var result: bool
	for position in Keyboard_button.size():
		if keyboard_action[position] == KeyboardAction.Released:
			result = true
			break
	return result

func set_keyboard_doubleclick_globally(time: float, amount: int):
	keyboard_limit_doubleclick_time.fill(time)
	keyboard_limit_doubleclick_amount.fill(amount)
func set_keyboard_doubleclick_amount(button: Keyboard_button, amount: int):
	keyboard_limit_doubleclick_amount[button] = amount
func set_keyboard_doubleclick_time(button: Keyboard_button, time: float):
	keyboard_limit_doubleclick_time[button] = time
func set_keyboard_doubleclick_amount_globally(amount: int):
	keyboard_limit_doubleclick_amount.fill(amount)
func set_keyboard_doubleclick_time_globally(time: float):
	keyboard_limit_doubleclick_time.fill(time)

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
func get_keyboard_current_presses() -> Array:
	var calc: Array = []
	for position in Keyboard_button.keys().size():
		if keyboard_pressed[position] == true:
			calc.append(Keyboard_button.find_key(position))
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
func any_joystick_button_just_pressed():
	var result: bool
	for position in Joystick_button.size():
		if joystick_action[position] == Action.JustPressed:
			result = true
			break
	return result
func any_joystick_button_pressed():
	var result: bool
	for position in Joystick_button.size():
		if joystick_action[position] == Action.Pressed:
			result = true
			break
	return result
func any_joystick_button_just_held():
	var result: bool
	for position in Joystick_button.size():
		if joystick_action[position] == Action.JustHeld:
			result = true
			break
	return result
func any_joystick_button_held():
	var result: bool
	for position in Joystick_button.size():
		if joystick_action[position] == Action.Held:
			result = true
			break
	return result
func any_joystick_button_just_released():
	var result: bool
	for position in Joystick_button.size():
		if joystick_action[position] == Action.JustReleased:
			result = true
			break
	return result
func any_joystick_button_released():
	var result: bool
	for position in Joystick_button.size():
		if joystick_action[position] == Action.Released:
			result = true
			break
	return result

func set_joystick_delay_globally(time: float):
	joystick_limit_delay.fill(time)
func set_joystick_delay(button: Joystick_button, time: float):
	joystick_limit_delay[button] = time
func set_joystick_doubleclick_time_globally(time: float):
	joystick_limit_doubleclick_time.fill(time)
func set_joystick_doubleclick_amount_globally(amount: int):
	joystick_limit_doubleclick_amount.fill(amount)
func set_joystick_doubleclick_time(button: Joystick_button, time: float):
	joystick_limit_doubleclick_time[button] = time
func set_joystick_doubleclick_amount(button: Joystick_button, amount: int):
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
## [b]If the "motion" parameter is either LAXIS or RAXIS, this function will set one of these parameter value's radius relative to the direction and axis.[/b][br]The radius specifies the angle from the starting axis (X axis for example) which will be identified as a diagonal input.[br]If the radius for the [b]Top Right, Bottom Right, Top Left and Bottom Left[/b] of the sides are started from it's respective axis and the current input is exceeding this radius, it will be identified as a diagonal input, since the current input is inside that radius.
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

## [b]Depending on the parameter's value, it returns the joystick's specific input's (parameter's value as specific input) current delay values as an Float.[/b]
func get_joystick_current_delay(button: Joystick_button) -> float:
	return joystick_current_delay[button]
## [b]Depending on the parameter's value, it returns the joystick's specific input's (parameter's value as specific input) limited delay values as an Float.[/b]
func get_joystick_limit_delay(button: Joystick_button) -> float:
	return joystick_limit_delay[button]
## [b]Returns all joystick's inputs' current delay values as an Array.[/b]
func get_all_joystick_current_delays() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_current_delay[position]
	return calc
## [b]Returns all joystick's inputs' limited delay values as an Array.[/b]
func get_all_joystick_limit_delays() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_limit_delay[position]
	return calc
## [b]Depending on the parameter's value, it returns the joystick's specific input's (parameter's value as specific input) current doubleclick Time values as an Float.[/b]
func get_joystick_current_doubleclick_time(button: Joystick_button) -> float:
	return joystick_current_doubleclick_time[button]
## [b]Depending on the parameter's value, it returns the joystick's specific input's (parameter's value as specific input) limited doubleclick Time values as an Float.[/b]
func get_joystick_limit_doubleclick_time(button: Joystick_button) -> float:
	return joystick_limit_doubleclick_time[button]
## [b]Depending on the parameter's value, it returns the joystick's specific input's (parameter's value as specific input) current doubleclick Amount values as an Intiger.[/b]
func get_joystick_current_doubleclick_amount(button: Joystick_button) -> int:
	return joystick_current_doubleclick_amount[button]
## [b]Depending on the parameter's value, it returns the joystick's specific input's (parameter's value as specific input) limited doubleclick Amount values as an Intiger.[/b]
func get_joystick_limit_doubleclick_amount(button: Joystick_button) -> int:
	return joystick_limit_doubleclick_time[button]
## [b]Returns the joystick's inputs' current doubleclick Time values as an Array.[/b]
func get_all_joystick_current_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_current_doubleclick_time[position]
	return calc
## [b]Returns the joystick's inputs' current doubleclick Amount values as an Array.[/b]
func get_all_joystick_current_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_current_doubleclick_amount[position]
	return calc
## [b]Returns the joystick's inputs' limited doubleclick Time values as an Array.[/b]
func get_all_joystick_limit_doubleclick_times() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_limit_doubleclick_time[position]
	return calc
## [b]Returns all the joystick's inputs' limited doubleclick Amount values as an Array.[/b]
func get_all_joystick_limit_doubleclick_amounts() -> Array:
	var calc: Array = []
	calc.resize(Joystick_button.keys().size())
	for position in Joystick_button.keys().size():
		calc[position] = joystick_limit_doubleclick_amount[position]
	return calc
## [b]Depending on the parameter's value, it returns that parameter's motion value, as a Variant.[/b][br]For [b]Triggers[/b] it returns as a Float and for [b]Sticks[/b] it returns as a Vector2.
func get_joystick_motion(motion: Joystick_motion):
	return joystick_motion[motion]
## [b]Returns the joystick's Left Stick values as a Vector2.[/b]
func get_joystick_laxis() -> Vector2:
	return Vector2(joystick_motion[Joystick_motion.LAXIS])
## [b]Returns the joystick's Right Stick values as a Vector2.[/b]
func get_joystick_raxis() -> Vector2:
	return Vector2(joystick_motion[Joystick_motion.RAXIS])
## [b]Returns the joystick's Left Trigger value as a Float.[/b]
func get_joystick_lt() -> float:
	return joystick_motion[Joystick_motion.LT]
## [b]Returns the joystick's Right Trigger value as a Float.[/b]
func get_joystick_rt() -> float:
	return joystick_motion[Joystick_motion.RT]
## [b]Returns all current joystick Input presses as an Array.[/b]
func get_joystick_current_presses() -> Array:
	var calc: Array = []
	for position in Joystick_button.keys().size():
		if joystick_pressed[position] == true:
			calc.append(Joystick_button.find_key(position))
	return calc

## [b]Depending on the parameter value, this function will reset all previous device's input values to 0, when having another device as current device.[/b][br]If this function has been set to [b]false[/b], then the values will be kept as if it was waiting for the next frame to calculate.
func set_device_reseting_values_on_switch(change: bool) -> void:
	reset_values = change

func _physics_process(delta) -> void:
	if is_outside_editor():
		if can_work(): work(delta)

## [b]Set whenever can VInput work or not.[/b][br]Depending on the parameter value, [b]can_work()[/b] function and [b]working[/b] variable will return as this function's parameter's value.
func set_work_state(value: bool) -> void:
	working = value

## [b]Returns either true or false, depending on it's work state.[/b][br]With [b]set_work_state()[/b] or directly changing [b]working[/b] variable, this function returns whatever value they have.[br]For example: if [b]working[/b] variable is [b]true[/b], then this function returns [b]true[/b] as well and vise versa.
func can_work() -> bool:
	return true if working == true else false

## [b]When called, device inputs are calculated and conditions will be performed.[/b][br]You can call it anytime, whenever you need to perform inputs. Useful for cutscenes, as in if you don't call the function while in a cutscene, VInput won't work, as the name of the function implies. [br]Better use this function with the [b]can_work()[/b] function as condition.
func work(delta) -> void:
	if is_outside_editor():
		apply_input_pressed(delta)
		
		if current_device == Device.Mouse: 
			for position in mouse_pressed.size():
				calculate_mouse(delta, position)
		elif current_device == Device.Keyboard:
			for position in keyboard_pressed.size():
				calculate_keyboard(delta, position)
		elif current_device == Device.Joystick:
			for position in joystick_pressed.size():
				calculate_joystick(delta, position)

## [b]Calculates all Mouse Inputs, using an Input event system and returns values depending on where the system currently is.[/b][br]The system consists of Actions, which will be used to identify the system's current state. Different states return to it's respective functions, which set values according to that state. It applies [b]calculate_mouse_doubleclick()[/b] function as well, so no need to call that function.
func calculate_mouse(delta, position) -> void:
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
## [b]Calculated all Mouse doubleclick related Time / Amount events and returns that state's respective function, simultaniously.[/b][br]No need to call this function, unless only the doubleclick related calculations are requested.
func calculate_mouse_doubleclick(delta, position: int, time: float, amount: int) -> void:
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

## [b]Calculates all Keyboard Inputs, using an Input event system and returns values depending on where the system currently is.[/b][br]The system consists of Actions, which will be used to identify the system's current state. Different states return to it's respective functions, which set values according to that state. It applies [b]calculate_keyboard_doubleclick()[/b] function as well, so no need to call that function.[br][br]This specific function doesn't include [b]Delay[/b] states, such as [b]Just Held[/b] and [b]Held[/b] state. Those are replaced with the [b]Just Pressed[/b] and [b]Pressed[/b] states.
func calculate_keyboard(delta, position) -> void:
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
## [b]Calculated all Keyboard doubleclick related Time / Amount events and returns that state's respective function, simultaniously.[/b][br]No need to call this function, unless only the doubleclick related calculations are requested.
func calculate_keyboard_doubleclick(delta, position: int, time: float, amount: int) -> void:
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

## [b]Calculates all Joystick Inputs, using an Input event system and returns values depending on where the system currently is.[/b][br]The system consists of Actions, which will be used to identify the system's current state. Different states return to it's respective functions, which set values according to that state. It applies [b]calculate_joystick_doubleclick()[/b] function as well, so no need to call that function.
func calculate_joystick(delta, position) -> void:
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
## [b]Calculated all Joystick doubleclick related Time / Amount events and returns that state's respective function, simultaniously.[/b][br]No need to call this function, unless only the doubleclick related calculations are requested.
func calculate_joystick_doubleclick(delta, position: int, time: float, amount: int) -> void:
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
