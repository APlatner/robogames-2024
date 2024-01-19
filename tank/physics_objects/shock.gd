class_name Shock
extends Node3D

var base_length: float = 0.48
var target: SuspensionArm

func _ready() -> void:
	var target_path := name.split("Shock")[0] + "SuspensionArm"
	target = get_parent().get_node(target_path) as SuspensionArm

func _process(_delta: float) -> void:
	var to := to_local(target.global_offset)
	to.x = 0
	var rot := atan2(to.z, to.y) + rotation.x + PI/2
	rotation.x = rot
	var distance_relative := base_length - to.length()
	(get_child(0) as Node3D).position.z = distance_relative
