extends CharacterBody3D

signal linear_speed_changed(speed: float)
signal linear_accel_changed(accel: Vector2)
signal angular_speed_changed(speed: float)

const MAX_LINEAR_SPEED: float = 5
const MAX_ANGULAR_SPEED: float = 5

var _linear_accel: float = 5
var _angular_accel: float = 5

var _linear_speed: float:
	set(value):
		_linear_speed = value
		linear_speed_changed.emit(_linear_speed)

var _angular_speed: float:
	set(value):
		_angular_speed = value
		angular_speed_changed.emit(_angular_speed)

var _current_accel: Vector2:
	set(value):
		_current_accel = value
		linear_accel_changed.emit(_current_accel)

var _previous_linear_speed: float

## TODO: implement drive/turn/aim/scan functions
func _physics_process(delta: float) -> void:
	var target_linear_speed := Input.get_axis('backward', 'forward') * MAX_LINEAR_SPEED
	var target_angular_speed := -Input.get_axis('left', 'right') * MAX_ANGULAR_SPEED
	_linear_speed = _handle_any_velocity(_linear_speed, target_linear_speed, _linear_accel * delta, MAX_LINEAR_SPEED)
	_angular_speed = _handle_any_velocity(_angular_speed, target_angular_speed, _angular_accel * delta, MAX_ANGULAR_SPEED)
	velocity = _linear_speed * global_basis.z
	rotate(transform.basis.y, _angular_speed * delta)
	_calc_accel()
	_previous_linear_speed = _linear_speed
	move_and_slide()


func _calc_accel():
	_current_accel.x = _linear_speed * _angular_speed
	_current_accel.y = (_previous_linear_speed - _linear_speed)


func _handle_any_velocity(current_speed: float, target_speed: float, accel: float, max_speed: float) -> float:
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
