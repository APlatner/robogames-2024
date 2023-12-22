extends CharacterBody3D


@export var shocks: Array[SuspensionPhysics]

@export var spring_constant: float = 10

var g = -9.8

var force = 0

func _ready() -> void:
	force += g

func _physics_process(delta: float) -> void:
	force = g + get_spring_force()
	velocity.y += force * delta

	move_and_slide()

func get_spring_force():
	var total_force := 0.0
	for shock in shocks:
		total_force += shock.force
	return total_force
