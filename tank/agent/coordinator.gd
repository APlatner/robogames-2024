class_name Coordinator
extends Node3D

@export var _local_signal_bus: LocalSignalBus

var _agent: Agent
var script_path: String:
	set(value):
		script_path = value
		var script := load(script_path) as Script
		_agent = script.new()
		_agent._onload()
		_agent_to_controller_signals()
		_controller_to_agent_signals()
		_agent.start()


func _ready() -> void:
	if not _agent:
		printerr("Agent script missing from Coordinator on ", get_parent_node_3d().name)


func _process(delta: float) -> void:
	if _agent:
		_agent.run(delta)


func _controller_to_agent_signals() -> void:
	_local_signal_bus.on_drive_speed_changed.connect(func(linear_speed: float, angular_speed: float):
		_agent.signal_bus.on_drive_speed_changed.emit(linear_speed, angular_speed)
	)
	_local_signal_bus.on_turret_angle_changed.connect(func(pan: float, tilt: float):
		_agent.signal_bus.on_turret_angle_changed.emit(pan, tilt)
	)
	_local_signal_bus.on_turret_speed_changed.connect(func(pan_speed: float, tilt_speed: float):
		_agent.signal_bus.on_turret_speed_changed.emit(pan_speed, tilt_speed)
	)
	_local_signal_bus.on_scanner_angle_changed.connect(func(pan: float):
		_agent.signal_bus.on_scanner_angle_changed.emit(pan)
	)
	_local_signal_bus.on_scanner_speed_changed.connect(func(pan_speed: float):
		_agent.signal_bus.on_scanner_speed_changed.emit(pan_speed)
	)

	_local_signal_bus.on_wobble.connect(func(roll: float, pitch: float, y: float):
		_agent.signal_bus.on_wobble.emit(roll, pitch, y)
	)

	_local_signal_bus.on_cannon_heat_changed.connect(func(cannon_heat: float):
		_agent.signal_bus.on_cannon_heat_changed.emit(cannon_heat)
	)
	_local_signal_bus.on_reloaded_changed.connect(func(reloaded: bool):
		_agent.signal_bus.on_reloaded_changed.emit(reloaded)
	)
	_local_signal_bus.on_overheated_changed.connect(func(overheated: bool):
		_agent.signal_bus.on_overheated_changed.emit(overheated)
	)

	_local_signal_bus.on_tank_scanned.connect(func(scan_position: Vector3, id: String):
		_agent.signal_bus.on_tank_scanned.emit(scan_position, id)
	)
	_local_signal_bus.on_obstacle_scanned.connect(func(scan_position: Vector3):
		_agent.signal_bus.on_obstacle_scanned.emit(scan_position)
	)


func _agent_to_controller_signals() -> void:
	_agent.signal_bus.on_drive.connect(func(linear_speed: float, angular_speed: float):
		_local_signal_bus.on_drive.emit(linear_speed, angular_speed)
	)
	_agent.signal_bus.on_aim.connect(func(pan_speed: float, tilt_speed: float):
		_local_signal_bus.on_aim.emit(pan_speed, tilt_speed)
	)
	_agent.signal_bus.on_scan.connect(func(pan_speed):
		_local_signal_bus.on_scan.emit(pan_speed)
	)
	_agent.signal_bus.on_shoot.connect(func(power: float):
		_local_signal_bus.on_shoot.emit(power)
	)

	## TODO: Remove temporary signal
	_agent.signal_bus.targeted.connect(func(target: Vector3):
		get_child(0).position = Vector3(target.x,0,target.z)
	)
