extends Agent

func start() -> void:
	print("Hello")


func run() -> void:
	drive(Input.get_axis("backward", "forward"), Input.get_axis("right", "left"))
	aim(Input.get_axis("pan_right", "pan_left"), Input.get_axis("tilt_up", "tilt_down"))
	if Input.is_action_pressed("shoot"):
		shoot(1)
