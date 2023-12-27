class_name SuspensionArm
extends Node3D

@onready var _wheel: Wheel = get_child(0)
@export var _sign: int = 1
#@export var _radius: float
@export var _offset_degrees: float

var _length: float
var _angle: float

var _previous_wheel_position: Vector3

var _previous_angle: float

func _ready() -> void:
	var length_vector = Vector2(_wheel.position.y, _wheel.position.z)
	_length = length_vector.length()
	#_angle = length_vector.angle()
	#print(_length)


func _handle_spin(root_node: Node3D):
	var movement_vector: Vector3 = _wheel.global_position - _previous_wheel_position
	var movement_amount = root_node.basis.z.dot(movement_vector)
	var angular_velocity: float = _angle - _previous_angle
	_wheel.rotate_x(movement_amount/_wheel._radius - angular_velocity)
	#print(movement_amount)
	_previous_wheel_position =_wheel.global_position
	_previous_angle = _angle



func handle_link_rotation(root_node: Node3D, pitch_angle: float):
	var p = root_node.to_local(global_position).y
	var d = 0.06
	if _sign == 1:
		_angle =  PI - asin((d-p+_wheel._radius)/_length) - deg_to_rad(pitch_angle)
	else:
		_angle =  asin((d-p+_wheel._radius)/_length) - deg_to_rad(pitch_angle)

	_angle += deg_to_rad(_offset_degrees)
	#print('p.y: ', p, ', d: ', d, ', a: ', angle)
	_set_link_angle(_angle)


func _set_link_angle(angle: float):
	rotation.x = angle
