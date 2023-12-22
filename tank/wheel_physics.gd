class_name WheelPhysics
extends RayCast3D

signal surface_hit(contact_point: Vector3)

var wheel_radius: float = 0.25



func _physics_process(delta: float) -> void:
	if is_colliding():
		surface_hit.emit(get_collision_point())


