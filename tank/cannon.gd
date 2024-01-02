class_name Cannon
extends Node3D

signal bullet_shot(power: float, turret_angle: float, barrel_angle: float)

var _bullet_instance: PackedScene = preload('res://tank/bullet.tscn')
var fire_offset := Vector3(0, 0, 1)

var root_node: Node3D

func _enter_tree() -> void:
	(root_node.get_node("Controller") as Controller).shoot_called.connect(_on_shoot_called)


## Callback to shoot from control script
func _on_shoot_called(power: float) -> void:
	var bullet := _bullet_instance.instantiate() as Bullet
	bullet.position = to_global(fire_offset)
	bullet.basis = Basis.looking_at(global_basis.z, Vector3.UP, true)
	bullet.initial_speed = 10
	get_tree().root.add_child(bullet)
	bullet_shot.emit(power, get_parent_node_3d().get_parent_node_3d().rotation.y, rotation.x)
