class_name Bullet
extends CharacterBody3D


var initial_speed: float
var _gravity = -5
@onready var _mesh_node := get_node("Mesh") as Node3D

func _ready() -> void:
	velocity = global_basis.z * initial_speed


func _physics_process(delta: float) -> void:
	velocity.y += _gravity * delta
	basis = Basis.looking_at(velocity, Vector3.UP, true)
	move_and_slide()


func _process(delta: float) -> void:
	_mesh_node.rotate_z(delta * velocity.length())
