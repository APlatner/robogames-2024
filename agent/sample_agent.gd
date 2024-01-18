extends Agent

var target: Vector3
var smooth_target: Vector3
var target_bound_pos: Vector3
var target_bound_neg: Vector3

var error_sum: float

enum {
	NOT_FOUND,
	ACTIVE,
	LOST_POS,
	LOST_NEG,
}

var scan_state := NOT_FOUND
var previous_scan_state := NOT_FOUND


func start() -> void:
	_author = "Jonathan Platner"
	_tank_name = "Tether"
	print("Introducing '", _tank_name, "' by ", _author)


func run(delta: float) -> void:
	drive(Input.get_axis("backward", "forward"), Input.get_axis("right", "left"))
	#aim(Input.get_axis("pan_right", "pan_left"), Input.get_axis("tilt_up", "tilt_down"))
	#scan(Input.get_axis("scan_right", "scan_left"))
	if scan_state == NOT_FOUND or scan_state == LOST_NEG:
		scan(1)
	elif scan_state == LOST_POS:
		scan(-1)

	if scan_state != NOT_FOUND:
		target = (target_bound_neg + target_bound_pos) / 2
		print(delta * _angular_speed)
		target = target.rotated(Vector3.UP, -_angular_speed/4)
		#print(_angular_speed)
		var proportional := get_turret_angle_to_target()

		error_sum += proportional
		aim(50*proportional - 2*_turret_pan_speed+error_sum, 0)
		smooth_target = 0.9 * smooth_target + target * 0.1
		error_sum /= 1.01
		signal_bus.targeted.emit(smooth_target)


func _on_obstacle_scanned(scan_position: Vector3):
	if scan_position.length() < 15:
		scan_state = ACTIVE
		if _scanner_pan_speed > 0:
			target_bound_pos = scan_position
		elif _scanner_pan_speed < 0:
			target_bound_neg = scan_position
	else:
		if scan_state == ACTIVE:
			if _scanner_pan_speed > 0:
				scan_state = LOST_POS
			elif _scanner_pan_speed < 0:
				scan_state = LOST_NEG


func get_turret_angle_to_target() -> float:
	var angle := atan2(smooth_target.x, smooth_target.z)
	#print("angle_to: ", angle, ", turret_angle: ", _turret_pan_angle, ", diff: ", wrapf(angle - _turret_pan_angle, -PI, PI))
	return wrapf(angle - _turret_pan_angle, -PI, PI)

