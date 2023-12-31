extends Node3D

@export var _pitch_damped_spring: DampedSpringParameters
@export var _roll_damped_spring: DampedSpringParameters
@export var _z_damped_spring: DampedSpringParameters

var _linear_speed: float
var _previous_linear_speed: float
var _linear_accel: Vector2

@onready var left_rear_suspension_link := get_node("Pitch/Mesh/Chassis/LeftRearSuspensionArm") as SuspensionArm
@onready var left_front_suspension_link := get_node("Pitch/Mesh/Chassis/LeftFrontSuspensionArm") as SuspensionArm
@onready var right_rear_suspension_link := get_node("Pitch/Mesh/Chassis/RightRearSuspensionArm") as SuspensionArm
@onready var right_front_suspension_link := get_node("Pitch/Mesh/Chassis/RightFrontSuspensionArm") as SuspensionArm
@onready var pitch_node := get_node("Pitch") as Node3D

## TODO: check if pitch/z/roll have changed enough - if they have, update the treads
## TODO: store a reference to parent instead of grabbing it each time
## TODO: make suspension links an array
## TODO: move all caterpillar track and shock motion here if needed
## TODO: z-height
## TODO: main signals
func _physics_process(delta: float) -> void:
	_calculate_spring_position(
			delta,
			_pitch_damped_spring,
			_linear_accel.y * 2)
	_calculate_spring_position(
			delta,
			_roll_damped_spring,
			_linear_accel.x / 55)
	pitch_node.rotate_x(deg_to_rad(_pitch_damped_spring.velocity))
	rotate_z(deg_to_rad(_roll_damped_spring.velocity))
	left_rear_suspension_link.handle_link_rotation(
			get_parent_node_3d(),
			_pitch_damped_spring.position
		)
	right_rear_suspension_link.handle_link_rotation(
			get_parent_node_3d(),
			_pitch_damped_spring.position
		)
	left_front_suspension_link.handle_link_rotation(
			get_parent_node_3d(),
			_pitch_damped_spring.position
		)
	right_front_suspension_link.handle_link_rotation(
			get_parent_node_3d(),
			_pitch_damped_spring.position
		)
	_previous_linear_speed = _linear_speed


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


func _on_root_linear_speed_changed(speed: float) -> void:
	_linear_speed = speed


func _on_root_linear_accel_changed(accel: Vector2) -> void:
	_linear_accel = accel
