class_name ChassisPhysics
extends RigidBody3D

@export var shocks: Array[SuspensionPhysics]


var g = -9.8

var force = 0

func _ready() -> void:
	force += g

func _physics_process(delta: float) -> void:
	get_spring_force()

func get_spring_force():
	for shock in shocks:
		apply_impulse(shock.force * Vector3.UP, shock.position)
		apply_impulse(Input.get_axis('left', 'right') * Vector3.RIGHT, shock.position)
