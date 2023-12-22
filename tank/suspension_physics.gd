class_name SuspensionPhysics
extends Node3D

var stiffness: float = 30
var damping: float = 5

var compressed_position: float = 1
var extended_position: float = 0
var compression_amount: float
var rest_position: float = -0.2

var force: float = 0
@export var wheel: WheelPhysics

var previous_compression_amount: float

func _physics_process(delta: float) -> void:
	compression_amount = (extended_position - wheel.position.y) / (extended_position - compressed_position)

	var velocity = -(compression_amount - previous_compression_amount) / delta


	force = compression_amount * stiffness - velocity * damping

	previous_compression_amount = compression_amount

func _on_wheel_surface_hit(contact_point: Vector3) -> void:


	if  -to_local(contact_point).y < wheel.wheel_radius:
		wheel.position.y = to_local(contact_point).y + wheel.wheel_radius
