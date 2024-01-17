class_name Agent

var _linear_speed: float
var _angular_speed: float
var _turret_pan_angle: float
var _turret_tilt_angle: float
var _scanner_pan_angle: float

var signal_bus: AgentSignalBus

func _onload() -> void:
	signal_bus = AgentSignalBus.new()
	signal_bus.on_tank_scanned.connect(_on_tank_scanned)
	signal_bus.on_drive_speed_changed.connect(func(linear_speed: float, angular_speed: float):
			_linear_speed = linear_speed
			_angular_speed = angular_speed
	)
	signal_bus.on_turret_angle_changed.connect(func(pan: float, tilt: float):
		_turret_pan_angle = pan
		_turret_tilt_angle = tilt
	)
	signal_bus.on_scanner_angle_changed.connect(func(pan: float):
		_scanner_pan_angle = pan
	)


func start() -> void:
	pass


func run() -> void:
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


func _on_tank_scanned(_scan_position: Vector3, _is_friendly: bool) -> void:
	pass
