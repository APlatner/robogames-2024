class_name RaycastWheel
extends RayCast3D


@export var travel: float = 0.5
var initial_travel: float = 0
var sprint_constant: float = 10
var damping_constant: float = 1

var force

func get_offset() -> float:
	if is_colliding():
		return (global_position - get_collision_point()).length()
	return 0


func _physics_process(delta: float) -> void:
	if is_colliding():
		global_position = get_collision_point() + Vector3.UP * 0.25
		force = sprint_constant * position
