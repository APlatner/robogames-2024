extends Node3D

var base_length: float = 0.48
@export var target: Node3D

func _process(delta: float) -> void:
	var to := to_local(target.global_position)
	to.x = 0
	var rot = atan2(to.z, to.y) + rotation.x + PI/2
	rotation.x = rot
	var distance_relative = base_length - to.length()
	get_child(0).position.z = distance_relative
