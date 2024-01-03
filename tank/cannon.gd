class_name Cannon
extends Node3D

var _bullet_instance: PackedScene = preload('res://tank/bullet.tscn')
var fire_offset := Vector3(0, 0, 1)

var root_node: Node3D

var _local_signal_bus: LocalSignalBus

func _enter_tree() -> void:
	_local_signal_bus.shoot_called.connect(_on_shoot_called)
	#(root_node.get_node("Controller") as Controller).shoot_called.connect(_on_shoot_called)


## Callback to shoot from control script
func _on_shoot_called(power: float) -> void:
	var bullet := _bullet_instance.instantiate() as Bullet
	bullet.position = to_global(fire_offset)
	bullet.basis = Basis.looking_at(global_basis.z, Vector3.UP, true)
	bullet.initial_speed = 10
	get_tree().root.add_child(bullet)
	_local_signal_bus.cannon_fired.emit(power, get_parent_node_3d().get_parent_node_3d().rotation.y, rotation.x)
