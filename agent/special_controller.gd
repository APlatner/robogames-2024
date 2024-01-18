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
	_agent.run(delta)


func _controller_to_agent_signals() -> void:
	_local_signal_bus.angular_speed_changed.connect(func(angular_speed: float):
		_agent.signal_bus.on_drive_speed_changed.emit(0, angular_speed)
	)
	_local_signal_bus.turret_speed_changed.connect(func(pan_speed: float, tilt_speed: float):
		_agent.signal_bus.on_turret_speed_changed.emit(pan_speed, tilt_speed)
	)
	_local_signal_bus.turret_rotation_changed.connect(func(pan: float, tilt: float):
		_agent.signal_bus.on_turret_angle_changed.emit(pan, tilt)
	)
	_local_signal_bus.scanner_speed_changed.connect(func(pan_speed: float):
		_agent.signal_bus.on_scanner_speed_changed.emit(pan_speed)
	)

	_local_signal_bus.can_shoot_changed.connect(func(can_shoot: bool):
		_agent.signal_bus.on_can_shoot_changed.emit(can_shoot)
	)

	_local_signal_bus.obstacle_scanned.connect(func(scan_position: Vector3):
		_agent.signal_bus.on_obstacle_scanned.emit(scan_position)
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
	_agent.signal_bus.targeted.connect(func(target: Vector3):
		get_child(0).position = Vector3(target.x,0,target.z)
	)
