extends CharacterBody3D

signal linear_speed_changed(speed: float)
signal linear_accel_changed(accel: Vector2)
signal angular_speed_changed(speed: float)

@export var _linear_accel: float = 5
@export var _angular_accel: float = 5

#var _suspension_links: Array[SuspensionArm]

const MAX_LINEAR_SPEED: float = 5
const MAX_ANGULAR_SPEED: float = 5

var _linear_speed: float:
	set(value):
		_linear_speed = value
		linear_speed_changed.emit(_linear_speed)
var _previous_linear_speed: float
var _angular_speed: float

var _current_accel: Vector2:
	set(value):
		_current_accel = value
		linear_accel_changed.emit(_current_accel)

# TODO: make this a resource container
#@export var _pitch_damped_spring: DampedSpringParameters
#var _pitch_angle: float
#var _pitch_speed: float
#var _pitch_accel: float
##var _pitch_stiffness: float = 3
##var _pitch_damping: float = 9
#
#var _roll_angle: float
#var _roll_speed: float
#var _roll_accel: float
#var _roll_stiffness: float = 3
#var _roll_damping: float = 6
#
#var _bounce_height: float
#var _bounce_speed: float
#var _bounce_accel: float
#var _bounce_stiffness: float = 6
#var _bounce_damping: float = 12



#func _ready() -> void:
	#_suspension_links.append($Roll/Pitch/Mesh/Chassis/LeftFrontSuspensionArm)
	#_suspension_links.append($Roll/Pitch/Mesh/Chassis/RightFrontSuspensionArm)
	#_suspension_links.append($Roll/Pitch/Mesh/Chassis/LeftRearSuspensionArm)
	#_suspension_links.append($Roll/Pitch/Mesh/Chassis/RightRearSuspensionArm)


func _physics_process(delta: float) -> void:
	var target_linear_speed = Input.get_axis('backward', 'forward') * MAX_LINEAR_SPEED
	var target_angular_speed = -Input.get_axis('left', 'right') * MAX_ANGULAR_SPEED
	_linear_speed = _handle_any_accel(_linear_speed, target_linear_speed, _linear_accel * delta, MAX_LINEAR_SPEED)
	_angular_speed = _handle_any_accel(_angular_speed, target_angular_speed, _angular_accel * delta, MAX_ANGULAR_SPEED)
	velocity = _linear_speed * global_basis.z
	rotate(transform.basis.y, _angular_speed * delta)
	#position.y = _bounce_height
	_calc_accel()

	#_handle_custom_physics(delta)
	#_tilt()
	_previous_linear_speed = _linear_speed
	_wheels_up()
	move_and_slide()
	#if Input.is_action_just_pressed('shoot'):
		#_bounce_speed = -0.05


func _wheels_up():
	#for link in _suspension_links:
		#pass
		#link.handle_link_rotation(self, _pitch_angle)


	#$LeftTreadInstance.speed = (
		#_linear_speed -
		#_angular_speed * 0.91 +
		#_pitch_speed * -1 * 0.17 * (PI-sin(_pitch_angle)))
	#$LeftTreadPath.q = abs(_pitch_angle) * 0.02 - _roll_angle * 0.012 + 0.3 - position.y * 1.5
	#$RightTreadInstance.speed = (
		#_linear_speed +
		#_angular_speed * 0.91 +
		#_pitch_speed * -1 * 0.17 * (PI-sin(_pitch_angle)))
	#$RightTreadPath.q = abs(_pitch_angle) * 0.02 + _roll_angle * 0.012 + 0.3 - position.y * 1.5
	pass

#func _handle_custom_physics(delta: float):
	#var pitch_data = _calculate_spring_position(
			#delta,
			#_pitch_accel,
			#_pitch_speed,
			#_pitch_angle,
			#_pitch_damped_spring,
			#_current_accel.y * 2)
	#_pitch_angle = pitch_data["position"]
	#_pitch_speed = pitch_data["velocity"]
	#_pitch_accel = pitch_data["acceleration"]
#
	##_roll_accel = (
		##-_roll_angle * _roll_stiffness * delta -
		##_roll_speed * _roll_damping * delta +
		##_current_accel.x / 55)
	##_roll_speed += _roll_accel
	##_roll_angle += _roll_speed
##
	##_bounce_accel = (
		##-_bounce_height * _bounce_stiffness * delta -
		##_bounce_speed * _bounce_damping * delta)
	##_bounce_speed += _bounce_accel
	##_bounce_height += _bounce_speed


#func _tilt():
	#$Roll.rotation_degrees = Vector3(0, 0, _roll_angle)
	#$Roll/Pitch.rotation_degrees = Vector3(_pitch_angle, 0, 0)


func _calc_accel():
	_current_accel.x = _linear_speed * _angular_speed
	_current_accel.y = (_previous_linear_speed - _linear_speed)


func _handle_any_accel(current_speed: float, target_speed: float, accel: float, max_speed: float) -> float:
	target_speed = clampf(target_speed, -max_speed, max_speed)
	if current_speed < target_speed:
		current_speed += accel
		if current_speed > target_speed:
			current_speed = target_speed
	elif current_speed > target_speed:
		current_speed -= accel
		if current_speed < target_speed:
			current_speed = target_speed
	return current_speed


#func _calculate_spring_position(
		#delta: float,
		#accel: float,
		#vel: float,
		#pos: float,
		#damped_spring: DampedSpringParameters,
		#external_accel: float = 0,
		#):
	#accel = (
		#- pos * damped_spring.stiffness * delta
		#- vel * damped_spring.damping * delta
		#+ external_accel
		#)
	#vel += accel
	#pos += vel
	#return {"position": pos, "velocity": vel, "acceleration": accel}
