extends VInput

func _ready():
	# This function will set a time frame on how long a specific Mouse button should be
	# stayed "Pressed". Without this function, the specific Mouse button will have no time
	# frame and the order for the Mouse Input will be:
	# "Just Pressed" -> "Just Held" -> "Held" -> "Just Released" -> "Released".
	set_mouse_delay(Mouse_button.LEFT, 0.5)
	
	# This function will set the maximum amount for the Mouse Input to trigger a Doubleclick.
	# It also sets a time frame for how long should it check for a Doubleclick. If the time frame
	# hits 0, then Doubleclick calculation resets. (both Time and Amount will be reset)
	set_doubleclick(Mouse_button.LEFT, 2, 0.6)
	pass

func _process(delta):
	# We use _process(delta) to have the best accurate calculations without any delays.
	# [Recommended] to use this function to detect Mouse Inputs.
	
	# This function will trigger calculations. Without it, all functions inside VInput
	# won't work and this function activates them. Useful for controlling how much it should
	# calculate. See it's documentation.
	# It has 3 parts: "calculate_mouse" - "calculate_keyboard" - "calculated_joystick".
	# If you set up conditions for them, only that part of the system will work. Improves efficiency
	# in coding and performance too.
	calculate_mouse(delta)
	
	# This is an example function, which you can use to detect Mouse Input.
	if mouse_button_doubleclicked(Mouse_button.LEFT): print("works")
