extends Node3D

@onready var _engine_idle: AudioStreamPlayer3D = $Idle
@onready var _engine_full_speed: AudioStreamPlayer3D = $FullSpeed
@onready var _engine_rev_up: AudioStreamPlayer3D = $RevUp
@onready var _engine_rev_down: AudioStreamPlayer3D = $RevDown
@onready var rev_up_length := _engine_rev_up.stream.get_length()
@onready var rev_down_length := _engine_rev_down.stream.get_length()

var _linear_speed := 0.0
var _angular_speed := 0.0
var _rev_up_anim := 0.0
var _rev_down_anim := 1.0


func _ready() -> void:
	get_parent().connect("linear_speed_changed", _on_linear_speed_changed)
	get_parent().connect("angular_speed_changed", _on_angular_speed_changed)

	_engine_idle.play()
	_engine_full_speed.play()
	_engine_full_speed.volume_db = linear_to_db(0.0)

func _process(delta: float) -> void:
	var linear_input = Input.get_axis("backward", "forward")
	var angular_input = -Input.get_axis("left", "right")
	if linear_input == 0.0 and angular_input == 0.0 and _rev_down_anim == 0.0:
		_rev_up_anim = 0.0
		_engine_rev_down.play()
		_engine_rev_up.stop()
		_rev_down_anim += delta / rev_down_length
	elif (linear_input / _linear_speed > 0 or angular_input / _angular_speed > 0) and _rev_up_anim == 0.0:
		_rev_down_anim = 0.0
		_engine_rev_up.play()
		_engine_rev_down.stop()
		_rev_up_anim += delta / rev_up_length

	_engine_idle.volume_db = linear_to_db(_rev_down_anim)
	_rev_down_anim += delta / rev_down_length * ceil(_rev_down_anim)
	_rev_down_anim = clampf(_rev_down_anim, 0.0, 1.0)

	_engine_full_speed.volume_db = linear_to_db(_rev_up_anim)
	_rev_up_anim += delta / rev_up_length * ceil(_rev_up_anim)
	_rev_up_anim = clampf(_rev_up_anim, 0.0, 1.0)
	_rev_up_anim = _rev_up_anim * float(!(linear_input / _linear_speed < 0 and angular_input / _angular_speed < 0))

func _on_linear_speed_changed(speed: float):
	_linear_speed = speed

func _on_angular_speed_changed(speed: float):
	_angular_speed = speed
