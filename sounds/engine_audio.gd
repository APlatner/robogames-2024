class_name EngineAudio
extends Node3D

@export var _local_signal_bus: LocalSignalBus

var _linear_input: float = 0.0
var _angular_input: float = 0.0
var _linear_speed: float = 0.0
var _angular_speed: float = 0.0
var _rev_up_anim: float = 0.0
var _rev_down_anim: float = 1.0

@onready var _engine_idle: AudioStreamPlayer3D = $Idle as AudioStreamPlayer3D
@onready var _engine_full_speed: AudioStreamPlayer3D = $FullSpeed as AudioStreamPlayer3D
@onready var _engine_rev_up: AudioStreamPlayer3D = $RevUp as AudioStreamPlayer3D
@onready var _engine_rev_down: AudioStreamPlayer3D = $RevDown as AudioStreamPlayer3D
@onready var rev_up_length: float = _engine_rev_up.stream.get_length()
@onready var rev_down_length: float= _engine_rev_down.stream.get_length()

func _ready() -> void:
	_local_signal_bus.linear_speed_changed.connect(_on_linear_speed_changed)
	_local_signal_bus.angular_speed_changed.connect(_on_angular_speed_changed)
	_local_signal_bus.drive_called.connect(_on_drive_called)

	_engine_idle.play()
	_engine_full_speed.play()
	_engine_full_speed.volume_db = linear_to_db(0.0)

func _process(delta: float) -> void:
	if _linear_input == 0.0 and _angular_input == 0.0 and _rev_down_anim == 0.0:
		_rev_up_anim = 0.0
		_engine_rev_down.play()
		_engine_rev_up.stop()
		_rev_down_anim += delta / rev_down_length
	elif (_linear_input / _linear_speed > 0 or _angular_input / _angular_speed > 0) and _rev_up_anim == 0.0:
		_rev_down_anim = 0.0
		_engine_rev_up.play()
		_engine_rev_down.stop()
		_rev_up_anim += delta / rev_up_length

	_engine_idle.volume_db = linear_to_db(_rev_down_anim)
	_rev_down_anim += delta / rev_down_length * ceilf(_rev_down_anim)
	_rev_down_anim = clampf(_rev_down_anim, 0.0, 1.0)

	_engine_full_speed.volume_db = linear_to_db(_rev_up_anim)
	_rev_up_anim += delta / rev_up_length * ceilf(_rev_up_anim)
	_rev_up_anim = clampf(_rev_up_anim, 0.0, 1.0)
	_rev_up_anim = _rev_up_anim * float(!(_linear_input / _linear_speed < 0 and _angular_input / _angular_speed < 0))

func _on_linear_speed_changed(speed: float) -> void:
	_linear_speed = speed

func _on_angular_speed_changed(speed: float) -> void:
	_angular_speed = speed
	
func _on_drive_called(linear_input: float, angular_input: float) -> void:
	_linear_input = linear_input
	_angular_input = angular_input
