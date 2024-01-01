extends Node3D

signal physics_elements_updated(pitch: float, roll: float, y: float)

@export var _pitch_damped_spring: DampedSpringParameters
@export var _roll_damped_spring: DampedSpringParameters
@export var _y_damped_spring: DampedSpringParameters

@export var _linear_tolerance: float = 0.002
@export var _angular_tolerance: float = 0.1

# Force update by setting previous positions to a non-zero value
var _previous_pitch: float = -1
var _previous_roll: float = -1
var _previous_y: float = -1

var _linear_accel: Vector2
var _suspension_arms: Array[SuspensionArm] = []

@onready var pitch_node := get_node("Pitch") as Node3D
@onready var root_node := get_parent_node_3d()

func _ready() -> void:
	_suspension_arms.append(get_node("Pitch/Mesh/Chassis/LeftRearSuspensionArm"))
	_suspension_arms.append(get_node("Pitch/Mesh/Chassis/LeftFrontSuspensionArm"))
	_suspension_arms.append(get_node("Pitch/Mesh/Chassis/RightRearSuspensionArm"))
	_suspension_arms.append(get_node("Pitch/Mesh/Chassis/RightFrontSuspensionArm"))


func _physics_process(delta: float) -> void:
	_calculate_spring_position(
		delta,
		_pitch_damped_spring,
		_linear_accel.y * 2
		)
	_calculate_spring_position(
		delta,
		_roll_damped_spring,
		_linear_accel.x / 55
		)
	_calculate_spring_position(
		delta,
		_y_damped_spring
		)

	# Only update all the physics elements if there's been a significant change since the last update
	if (
		absf(_y_damped_spring.position - _previous_y) > _linear_tolerance
		or absf(_pitch_damped_spring.position - _previous_pitch) > _angular_tolerance
		or absf(_roll_damped_spring.position - _previous_roll) > _angular_tolerance
		):
		_update_suspension_and_tracks()


func _update_suspension_and_tracks():
	_previous_y = _y_damped_spring.position
	_previous_pitch = _pitch_damped_spring.position
	_previous_roll = _roll_damped_spring.position

	pitch_node.rotation_degrees.x = _pitch_damped_spring.position
	rotation_degrees.z = _roll_damped_spring.position
	position.y = _y_damped_spring.position

	for arm in _suspension_arms:
		arm.handle_link_rotation(root_node, _pitch_damped_spring.position)

	physics_elements_updated.emit(
		_pitch_damped_spring.position,
		_roll_damped_spring.position,
		_y_damped_spring.position
		)


func _calculate_spring_position(
		delta: float,
		damped_spring: DampedSpringParameters,
		external_accel: float = 0,
		):
	damped_spring.acceleration = (
		- damped_spring.position * damped_spring.stiffness * delta
		- damped_spring.velocity * damped_spring.damping * delta
		+ external_accel
		)
	damped_spring.velocity += damped_spring.acceleration
	damped_spring.position += damped_spring.velocity


func _on_root_linear_accel_changed(accel: Vector2) -> void:
	_linear_accel = accel


func _on_tank_barrel_hit_rotation_limit(speed: float, turret_angle: float) -> void:
	_pitch_damped_spring.velocity = -speed * sin(turret_angle) * 0.2
	_roll_damped_spring.velocity = -speed * cos(turret_angle) * 0.2
