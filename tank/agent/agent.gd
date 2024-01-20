class_name Agent

@warning_ignore("unused_private_class_variable")
var _author: String
@warning_ignore("unused_private_class_variable")
var _tank_name: String

var _linear_speed: float
var _angular_speed: float
var _turret_pan_angle: float
var _turret_pan_speed: float
var _turret_tilt_angle: float
var _turret_tilt_speed: float
var _scanner_pan_angle: float
var _scanner_pan_speed: float

var _body_roll: float
var _body_pitch: float
var _body_y: float

var _reloaded: bool
var _overheated: bool
var _cannon_heat: float

var signal_bus: AgentSignalBus

## Executed by the coordinator when script is loaded. Modify for a fully-customized, non-functional tank.
func _onload() -> void:
	signal_bus = AgentSignalBus.new()
	signal_bus.on_tank_scanned.connect(_on_tank_scanned)
	signal_bus.on_obstacle_scanned.connect(_on_obstacle_scanned)
	signal_bus.on_nothing_scanned.connect(_on_nothing_scanned)
	signal_bus.on_drive_speed_changed.connect(func(linear_speed: float, angular_speed: float):
			_linear_speed = linear_speed
			_angular_speed = angular_speed
	)
	signal_bus.on_turret_angle_changed.connect(func(pan: float, tilt: float):
		_turret_pan_angle = pan
		_turret_tilt_angle = tilt
	)
	signal_bus.on_turret_speed_changed.connect(func(pan_speed: float, tilt_speed: float):
		_turret_pan_speed = pan_speed
		_turret_tilt_speed = tilt_speed
	)
	signal_bus.on_scanner_angle_changed.connect(func(pan: float):
		_scanner_pan_angle = pan
	)
	signal_bus.on_scanner_speed_changed.connect(func(pan_speed: float):
		_scanner_pan_speed = pan_speed
	)

	signal_bus.on_wobble.connect(func(roll: float, pitch: float, y: float):
		_body_roll = roll
		_body_pitch = pitch
		_body_y = y
	)

	signal_bus.on_cannon_heat_changed.connect(func(cannon_heat: float):
		_cannon_heat = cannon_heat
	)
	signal_bus.on_reloaded_changed.connect(func(reloaded: bool):
		_reloaded = reloaded
	)
	signal_bus.on_overheated_changed.connect(func(overheated: bool):
		_overheated = overheated
	)



func start() -> void:
	pass


func run(_delta: float) -> void:
	pass


## commands the tank to move forward/backward and turn left/right
## linear_speed is a float between -1 and 1
## 		where -1 is full reverse and 1 is full forward
## angular_speed is a float between -1 and 1
## 		where -1 is full clockwise and 1 is full counter-clockwise
func drive(linear_speed: float, angular_speed: float) -> void:
	signal_bus.on_drive.emit(linear_speed, angular_speed)


func aim(pan_speed: float, tilt_speed: float) -> void:
	signal_bus.on_aim.emit(pan_speed, tilt_speed)


func scan(pan_speed: float) -> void:
	signal_bus.on_scan.emit(pan_speed)


func shoot(power: float) -> void:
	signal_bus.on_shoot.emit(power)


func _on_tank_scanned(_scan_position: Vector3, _id: String) -> void:
	pass


func _on_obstacle_scanned(_scan_position: Vector3):
	pass


func _on_nothing_scanned():
	pass
