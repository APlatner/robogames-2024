class_name SuspensionArm
extends Node3D

enum Direction{
	FRONT,
	BACK,
}

@onready var _roller: Roller = get_child(0) as Roller
var side: int = Direction.BACK

var _length: float

var _offset: Vector3
var global_offset: Vector3:
	get:
		return to_global(_offset)


func _ready() -> void:
	var length_vector = Vector2(_roller.position.y, _roller.position.z)
	_length = length_vector.length()
	if side == Direction.BACK:
		_offset = Vector3(0, -0.39, -0.4)
	else:
		_offset = Vector3(0, 0.39, -0.4)


func handle_link_rotation(root_node: Node3D, pitch_angle: float):
	var p := root_node.to_local(global_position).y
	var d := 0.06 - root_node.position.y
	var angle: float
	if side == Direction.BACK:
		angle =  PI - asin((d-p+_roller.radius)/_length) - deg_to_rad(pitch_angle)
	else:
		angle =  asin((d-p+_roller.radius)/_length) - deg_to_rad(pitch_angle)

	rotation.x = angle
