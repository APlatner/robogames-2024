class_name Agent

var _linear_speed: float
var _angular_speed: float
var _turret_angle: Vector2

var agent_signal_bus: AgentSignalBus

func _onload() -> void:
	agent_signal_bus = AgentSignalBus.new()
	agent_signal_bus.on_tank_scanned.connect(_on_tank_scanned)
	agent_signal_bus.on_drive_speed_changed.connect(func(linear_speed: float, angular_speed: float):
			_linear_speed = linear_speed
			_angular_speed = angular_speed
	)
	agent_signal_bus.on_scanner_angle_changed.connect(func(pan: float, tilt: float):
		_turret_angle = Vector2(pan, tilt)
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
	agent_signal_bus.on_drive.emit(linear_speed, angular_speed)


func aim(pan_speed: float, tilt_speed: float) -> void:
	agent_signal_bus.on_aim.emit(pan_speed, tilt_speed)


func scan(pan_speed: float) -> void:
	agent_signal_bus.on_scan.emit(pan_speed)


func shoot(power: float) -> void:
	agent_signal_bus.on_shoot.emit(power)


func _on_tank_scanned(scan_position: Vector3, is_friendly: bool) -> void:
	pass
