class_name Controller
extends Node3D

@export var _local_signal_bus: LocalSignalBus
var author: String

func _process(_delta: float) -> void:
	_local_signal_bus.drive_called.emit(
		Input.get_axis('backward', 'forward'),
		Input.get_axis('right', 'left')
	)
	_local_signal_bus.aim_called.emit(
		Input.get_axis('pan_right', 'pan_left'),
		Input.get_axis('tilt_down', 'tilt_up')
	)
	_local_signal_bus.scan_called.emit(
		Input.get_axis('scan_right', 'scan_left'),
	)
	if Input.is_action_just_pressed('shoot'):
		_local_signal_bus.shoot_called.emit(1)


func test():
	print('do something')
