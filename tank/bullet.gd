class_name Bullet
extends CharacterBody3D


var _gravity: float = -5
var _directional_velocity: Vector3

var initial_speed: float
var parent_velocity: Vector3
var visual_size: Vector3

@onready var _mesh_node := get_node("Mesh") as Node3D

func _ready() -> void:
	_directional_velocity = global_basis.z * initial_speed
	_mesh_node.scale_object_local(visual_size)


func _physics_process(delta: float) -> void:
	_directional_velocity.y += _gravity * delta
	velocity = _directional_velocity + parent_velocity
	basis = Basis.looking_at(_directional_velocity, Vector3.UP, true)
	move_and_slide()


func _process(delta: float) -> void:
	_mesh_node.rotate_z(delta * velocity.length())
