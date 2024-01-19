class_name EngineAudio
extends Node3D

var _local_signal_bus: LocalSignalBus

var _linear_speed: float
var _angular_speed: float

@onready var _engine_idle  := $Idle as AudioStreamPlayer3D
@onready var _engine_full_speed := $FullSpeed as AudioStreamPlayer3D


func _enter_tree() -> void:
	_local_signal_bus = get_parent().get_node("LocalSignalBus") as LocalSignalBus


func _ready() -> void:
	#_local_signal_bus.linear_speed_changed.connect(_on_linear_speed_changed)
	#_local_signal_bus.angular_speed_changed.connect(_on_angular_speed_changed)
	_local_signal_bus.on_drive_speed_changed.connect(func(linear_speed: float, angular_speed: float):
		_linear_speed = linear_speed
		_angular_speed = angular_speed
	)
	#_local_signal_bus.drive_called.connect(_on_drive_called)

	_engine_idle.play()
	_engine_full_speed.play()
	_engine_full_speed.volume_db = linear_to_db(0.0)


func _process(_delta: float) -> void:
	var left: float = absf(-_angular_speed + _linear_speed)
	var right: float = absf(_angular_speed + _linear_speed)
	var factor: float = (left + right) / 5 - 1
	_engine_idle.pitch_scale = 1 + (factor + 1) / 4
	_engine_full_speed.volume_db = linear_to_db(sqrt(0.5 * (1 + factor)))
	_engine_full_speed.pitch_scale = 1 + (factor + 1) / 16


#func _on_linear_speed_changed(speed: float) -> void:
	#_linear_speed = speed
#
#
#func _on_angular_speed_changed(speed: float) -> void:
	#_angular_speed = speed
#
#func _on_drive_called(linear_input: float, angular_input: float) -> void:
	#_linear_speed = linear_input
	#_angular_speed = angular_input
