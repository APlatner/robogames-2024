class_name Roller
extends Node3D

@export var radius: float = 1

var previous_position: Vector3

var parent_angle: float
var previous_parent_angle: float


func _physics_process(_delta: float) -> void:
	_spin()


func _spin():
	parent_angle = get_parent_node_3d().rotation.x

	var angular_velocity: float = parent_angle - previous_parent_angle
	var forward: Vector3 = global_basis.x.cross(Vector3.UP)
	var move_delta = global_position - previous_position
	var forward_velocity = forward.dot(move_delta)
	rotate_x(forward_velocity/radius - angular_velocity)

	previous_position = global_position
	previous_parent_angle = parent_angle
