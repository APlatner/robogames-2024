extends Node3D

@export var _local_signal_bus: LocalSignalBus
@export_file("*.gd") var script_path: String
var _agent: Agent


func _enter_tree() -> void:
	var script := load(script_path) as Script
	_agent = script.new()
	_agent._onload()
	_agent_to_controller_signals()
	_controller_to_agent_signals()


func _ready() -> void:
	_agent.start()


func _process(delta: float) -> void:
	_agent.run()


func _controller_to_agent_signals() -> void:
	_local_signal_bus.turret_rotation_changed.connect(func(turret_rotation: Vector2):
		_agent.signal_bus.on_turret_angle_changed.emit(turret_rotation.x, turret_rotation.y)
	)


func _agent_to_controller_signals() -> void:
	_agent.signal_bus.on_drive.connect(func(linear_speed: float, angular_speed: float):
		_local_signal_bus.drive_called.emit(linear_speed, angular_speed)
	)
	_agent.signal_bus.on_aim.connect(func(pan_speed: float, tilt_speed: float):
		_local_signal_bus.aim_called.emit(pan_speed, tilt_speed)
	)
	_agent.signal_bus.on_scan.connect(func(pan_speed):
		_local_signal_bus.scan_called.emit(pan_speed)
	)
	_agent.signal_bus.on_shoot.connect(func(power: float):
		_local_signal_bus.shoot_called.emit(power)
	)
