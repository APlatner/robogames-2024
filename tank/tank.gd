class_name Tank
extends CharacterBody3D

const MAX_LINEAR_SPEED: float = 5
const MAX_ANGULAR_SPEED: float = 5
const MAX_PAN_SPEED: float = 8
const MAX_TILT_SPEED: float = 8
const MAX_SCAN_SPEED: float = 20

const PAN_ACCEL: float = 15
const TILT_ACCEL: float = 15
const SCAN_ACCEL: float = 50
const LINEAR_ACCEL: float = 6
const ANGULAR_ACCEL: float = 6

@export var _local_signal_bus: LocalSignalBus

var _target_linear_speed: float
var _target_angular_speed: float
var _target_pan_speed: float
var _target_tilt_speed: float
var _target_scan_speed: float

var _linear_speed: float:
	set(value):
		_linear_speed = value
		_local_signal_bus.linear_speed_changed.emit(_linear_speed)

var _angular_speed: float:
	set(value):
		_angular_speed = value
		_local_signal_bus.angular_speed_changed.emit(_angular_speed)

var _pan_speed: float
var _tilt_speed: float
var _scan_speed: float

var _current_accel: Vector2:
	set(value):
		_current_accel = value
		_local_signal_bus.linear_accel_changed.emit(_current_accel)

var _previous_linear_speed: float
var _previous_velocity: Vector3

@onready var _turret_node := get_node(
	"Roll/Pitch/Mesh/Chassis/TurretDriveKey"
) as Node3D
@onready var _barrel_node := get_node(
	"Roll/Pitch/Mesh/Chassis/TurretDriveKey/Turret/Barrel"
) as Node3D
@onready var _scanner_node := get_node(
	"Roll/Pitch/Mesh/Chassis/TurretDriveKey/Turret/ScannerBody"
) as Node3D

@onready var controller: Controller = get_child(0) as Controller


func _ready() -> void:
	_local_signal_bus.drive_called.connect(_on_drive_called)
	_local_signal_bus.aim_called.connect(_on_aim_called)
	_local_signal_bus.scan_called.connect(_on_scan_called)
	controller.start()
	
func _physics_process(delta: float) -> void:
	controller.run(delta)
	_update_velocities(delta)

	# Apply velocities
	velocity = _linear_speed * global_basis.z
	if velocity != _previous_velocity:
		_local_signal_bus.velocity_changed.emit(velocity)
	_previous_velocity = velocity
	rotate_y(_angular_speed * delta)
	_turret_node.rotate_y(_pan_speed * delta)
	_barrel_node.rotate_x(_tilt_speed * delta)
	_local_signal_bus.turret_rotation_changed.emit(_turret_node.rotation.y)

	# Limit barrel rotation
	if _barrel_node.rotation_degrees.x > 15 + 0.1:
		_local_signal_bus.barrel_end_of_travel.emit(_tilt_speed, _turret_node.rotation.y)
		_tilt_speed = 0
		_barrel_node.rotation_degrees.x = 15
	elif _barrel_node.rotation_degrees.x < -100 - 0.1:
		_local_signal_bus.barrel_end_of_travel.emit(_tilt_speed, _turret_node.rotation.y)
		_tilt_speed = 0
		_barrel_node.rotation_degrees.x = -100

	_scanner_node.rotate_y(_scan_speed * delta)

	_calc_accel()
	_previous_linear_speed = _linear_speed
	move_and_slide()
	_local_signal_bus.tank_rotation_changed.emit(rotation.y)

func _update_velocities(delta: float) -> void:
	_linear_speed = _handle_any_velocity(
		_linear_speed,
		_target_linear_speed,
		LINEAR_ACCEL * delta * _sample_accel_curve(_linear_speed, _target_linear_speed, MAX_LINEAR_SPEED),
		MAX_LINEAR_SPEED
	)
	_angular_speed = _handle_any_velocity(
		_angular_speed,
		_target_angular_speed,
		ANGULAR_ACCEL * delta * _sample_accel_curve(_angular_speed, _target_angular_speed, MAX_ANGULAR_SPEED),
		MAX_ANGULAR_SPEED
	)
	_pan_speed = _handle_any_velocity(
		_pan_speed,
		_target_pan_speed,
		PAN_ACCEL * delta * _sample_accel_curve(_pan_speed, _target_pan_speed, MAX_PAN_SPEED),
		MAX_PAN_SPEED
	)
	_tilt_speed = _handle_any_velocity(
		_tilt_speed,
		_target_tilt_speed,
		TILT_ACCEL * delta * _sample_accel_curve(_tilt_speed, _target_tilt_speed, MAX_TILT_SPEED),
		MAX_TILT_SPEED
	)
	if _tilt_speed > 0 and _barrel_node.rotation_degrees.x >= 15:
		_tilt_speed = 0
	elif _tilt_speed < 0 and _barrel_node.rotation_degrees.x <= -100:
		_tilt_speed = 0

	_scan_speed = _handle_any_velocity(
		_scan_speed,
		_target_scan_speed,
		SCAN_ACCEL * delta * _sample_accel_curve(_scan_speed, _target_scan_speed, MAX_SCAN_SPEED),
		MAX_SCAN_SPEED
	)


func _calc_accel() -> void:
	_current_accel.x = _linear_speed * _angular_speed
	_current_accel.y = (_previous_linear_speed - _linear_speed)


func _handle_any_velocity(
		current_speed: float,
		target_speed: float,
		accel: float,
		max_speed: float
	) -> float:
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


func _sample_accel_curve(
		current_speed: float,
		target_speed: float,
		max_speed: float
	) -> float:
	if (absf(current_speed) < absf(target_speed)
			and signf(current_speed) == signf(target_speed)):
		return -0.1 * (absf(current_speed/max_speed) - 2) ** 2 + 1
	else:
		return 1.5


## Callback to set the drive parameters based on the child control node's signal
func _on_drive_called(linear_input: float, angular_input: float = 0) -> void:
	linear_input = clampf(linear_input, -1, 1)
	angular_input = clampf(angular_input, -1, 1)
	_target_linear_speed = MAX_LINEAR_SPEED * linear_input
	_target_angular_speed = MAX_ANGULAR_SPEED * angular_input


## Callback to set the aim parameters based on the child control node's signal
func _on_aim_called(pan_input: float, tilt_input: float = 0) -> void:
	pan_input = clampf(pan_input, -1, 1)
	tilt_input = clampf(tilt_input, -1, 1)
	_target_pan_speed = MAX_PAN_SPEED * pan_input
	_target_tilt_speed = MAX_TILT_SPEED * tilt_input


## Callback to set the scan parameters based on the child control node's signal
func _on_scan_called(scan_input: float) -> void:
	scan_input = clampf(scan_input, -1, 1)
	_target_scan_speed = MAX_SCAN_SPEED * scan_input
