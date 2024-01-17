extends Node3D

@export var _local_signal_bus: LocalSignalBus
@export_file("*.gd") var script_path: String
var _agent: Agent


func _enter_tree() -> void:
	var script := load(script_path) as Script
	_agent = script.new()
	_agent._onload()
	_controller_to_agent_signals()


func _ready() -> void:
	_agent.start()


func _process(delta: float) -> void:
	_agent.run()


func _controller_to_agent_signals():
	_agent.agent_signal_bus.on_drive.connect(func(linear: float, angular: float):
		_local_signal_bus.drive_called.emit(linear, angular)
	)
	_agent.agent_signal_bus.on_aim.connect(func(pan: float, tilt: float):
		_local_signal_bus.aim_called.emit(pan, tilt)
	)
	_agent.agent_signal_bus.on_shoot.connect(func(power: float):
		_local_signal_bus.shoot_called.emit(power)
	)
