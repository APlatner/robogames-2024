class_name Controller
extends Node3D

@export var _local_signal_bus: LocalSignalBus
var author: String = "Unknown"
var agent_name: String = "Cannon Fodder"

func _enter_tree() -> void:
	_local_signal_bus.enemy_scanned.connect(_on_enemy_scanned)

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
	if Input.is_action_pressed('shoot'):
		_local_signal_bus.shoot_called.emit(1)


func _on_enemy_scanned(scan_position, id):
	pass

func _begin():
	pass
