class_name AgentSignalBus

signal on_drive(linear_speed: float, angular_speed: float)
signal on_aim(pan_speed: float, tilt_speed: float)
signal on_scan(pan_speed: float)
signal on_shoot(power: float)
signal on_tank_scanned(scan_position: Vector3, id: String)
signal on_obstacle_scanned(scan_position: Vector3)
signal on_nothing_scanned

signal on_wobble(roll: float, pitch: float, y: float)
signal on_drive_speed_changed(linear_speed: float, angular_speed: float)
signal on_turret_angle_changed(pan: float, tilt: float)
signal on_turret_speed_changed(pan_speed: float, tilt_speed: float)
signal on_scanner_angle_changed(pan: float)
signal on_scanner_speed_changed(pan_speed: float)

signal on_cannon_heat_changed(cannon_heat: float)
signal on_can_shoot_changed(can_shoot: bool)
signal on_reloaded_changed(reloaded: bool)
signal on_overheated_changed(overheated: bool)

signal targeted(target: Vector3)
