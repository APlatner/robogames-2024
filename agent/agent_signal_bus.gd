class_name AgentSignalBus

signal on_drive(linear_speed: float, angular_speed: float)
signal on_aim(pan_speed: float, tilt_speed: float)
signal on_scan(pan_speed: float)
signal on_shoot(power: float)
signal on_tank_scanned(scan_position: Vector3, is_friendly: bool)
signal on_drive_speed_changed(linear_speed: float, angular_speed: float)
signal on_turret_angle_changed(pan: float, tilt: float)
signal on_scanner_angle_changed(pan: float)


