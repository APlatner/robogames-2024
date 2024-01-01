class_name Controller
extends Node3D

signal drive_called(linear_input: float, angular_input: float)
signal aim_called(pan_input: float, tilt_input: float)
signal scan_called(scan_input: float)
signal shoot_called(power: float)


func _process(delta: float) -> void:
	drive_called.emit(
		Input.get_axis('backward', 'forward'),
		Input.get_axis('right', 'left')
	)
	aim_called.emit(
		Input.get_axis('pan_right', 'pan_left'),
		Input.get_axis('tilt_down', 'tilt_up')
	)
	scan_called.emit(
		Input.get_axis('scan_right', 'scan_left'),
	)
	if Input.is_action_just_pressed('shoot'):
		shoot_called.emit(1)
