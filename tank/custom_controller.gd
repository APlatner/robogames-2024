extends Controller

var move_time: float = 0.0
var fire_rate: float = 1.0
var shot_fired: float = 1.0

# Called when the node enters the scene tree for the first time.
func start() -> void:
	target_location = Vector3.FORWARD * 10 + Vector3.BACK * 20
	pass # Replace with function body.

# Called every update
func run(delta: float) -> void:
	var target_normal: Vector3 = target_location.normalized()
	if move_time > 4.0:
		move_time = 0.0
		drive(0.0, 0.0)
	elif move_time > 3.0:
		drive(1.0, 1.0)
	move_time += delta
	var y: float = asin(target_normal.z)
	var x: float = acos(target_normal.x)
	var target_angle: float = 0.0
	if x > PI / 2 && y < 0:
		target_angle = 2 * PI - x
	elif x < PI / 2 && y > 0:
		target_angle = y
	elif x < PI / 2 && y < 0:
		target_angle = 2 * PI + y
	else:
		target_angle = x
	target_angle = wrapf(target_angle, 0, 2 * PI) - wrapf(turret_rotation.y + chassis_rotation, 0, 2 * PI)
	aim(clampf(target_angle, -1.0, 1.0), 0.0)
	if abs(clampf(target_angle, -1.0, 1.0)) < 0.1 and shot_fired == 0.0:
		aim(0.0,0.0)
		shoot(1.0)
		shot_fired = 1.0
		print(target_angle)
		_local_signal_bus.enemy_scanned.emit(Vector3(-target_location.z, 0.0, target_location.x), 0)
	elif shot_fired > 0.0:
		shot_fired -= delta
		shot_fired = clampf(shot_fired, 0.0, 1.0)
