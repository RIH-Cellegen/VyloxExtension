extends VInput

func _process(delta):
	VInput_work(delta)
	
	print(get_all_actions())
