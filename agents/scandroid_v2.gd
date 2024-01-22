extends Agent

var _tank_in_view := false
var _tank_position := Vector3.ZERO
var _previous_tank_position := Vector3.ZERO

func run(delta: float):
	if not _tank_in_view:
		scan(0.3 - _angular_speed / 20 - _turret_pan_speed / 20)
	else:
		_lock_target(_tank_position, delta)


	drive(Input.get_axis("backward", "forward") ,Input.get_axis("right", "left"))
	if (Input.is_action_just_pressed("shoot")):
		shoot(1)
	#aim(1, 0)
	#aim(0.2, 0)


	var diff := (
		_tank_position
		- _previous_tank_position.rotated(Vector3.UP, -_angular_speed * delta)
		)
	signal_bus.targeted.emit(_tank_position + diff / delta + Vector3.UP * 1.5)
	_aim_at_target(_tank_position + diff / delta + Vector3.UP * 1.5, delta)
	_previous_tank_position = _tank_position


func _aim_at_target(target_position: Vector3, delta: float):
	var angle := atan2(target_position.x, target_position.z)
	_turret_angle_control(angle, _compute_turret_elevation(target_position, -5, 10), delta)


func _lock_target(target_position: Vector3, delta: float):
	var angle := atan2(target_position.x, target_position.z)
	_scanner_angle_control(angle - _turret_pan_angle, delta)


func _scanner_angle_control(target_angle: float, delta: float) -> void:
	var error := wrapf(target_angle - _scanner_pan_angle, -PI,PI)
	scan(error - _angular_speed / 20 - _turret_pan_speed / 20)

func _turret_angle_control(target_angle: float, target_tilt: float, delta: float):
	var error := wrapf(target_angle - _turret_pan_angle, -PI,PI)
	var tilt_error := target_tilt * 0.85 - _turret_tilt_angle
	aim(error - _angular_speed / 8, tilt_error)


func _compute_turret_elevation(target_position: Vector3, gravity: float, muzzle_speed: float):
	var distance = target_position.length()
	var angle = asin(distance * gravity / muzzle_speed / muzzle_speed) / 2
	return angle


#func _ext_shoot():
	#shoot(1)
	#var linear


func _on_tank_scanned(scan_position: Vector3, _id: String):
	_tank_in_view = true
	_tank_position = scan_position


func _on_obstacle_scanned(scan_position: Vector3):
	_tank_in_view = false


func _on_nothing_scanned():
	_tank_in_view = false
