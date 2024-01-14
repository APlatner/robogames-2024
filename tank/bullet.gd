class_name Bullet
extends CharacterBody3D


var _gravity: float = -5
var _directional_velocity: Vector3

var initial_speed: float
var parent_velocity: Vector3
var visual_size: Vector3

var _whistle_played := false
var _pitch_range: float = 0.2

@onready var _mesh_node := get_node("Mesh") as Node3D
@onready var _audio_node := get_node("AudioStreamPlayer3D") as AudioStreamPlayer3D

func _ready() -> void:
	_directional_velocity = global_basis.z * initial_speed
	_mesh_node.scale_object_local(visual_size)
	_audio_node.pitch_scale = (randf() * 2 - 1) * _pitch_range + 1


func _physics_process(delta: float) -> void:
	_directional_velocity.y += _gravity * delta
	velocity = _directional_velocity + parent_velocity
	basis = Basis.looking_at(_directional_velocity, Vector3.UP, true)
	move_and_slide()


func _process(delta: float) -> void:
	_mesh_node.rotate_z(delta * velocity.length())
	if velocity.y < 0 and not _whistle_played:
		_audio_node.play()
		_whistle_played = true
	var fall_slope = absf(velocity.y) / Vector2(velocity.x, velocity.z).length()
	_audio_node.volume_db = linear_to_db(fall_slope / 10)
	#print(linear_to_db(absf(velocity.y)))
