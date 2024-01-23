class_name LocalSignalBus
extends Node3D

signal caterpillar_tracks_updated
signal physics_elements_updated(pitch: float, roll: float, y: float)
signal velocity_changed(velocity: Vector3)
signal linear_accel_changed(accel: float)
signal angular_accel_changed(accel: float)
signal barrel_end_of_travel(barrel_speed: float, turret_angle: float)
signal cannon_fired(power: float, turret_angle: float, barrel_angle: float)
signal on_impacted(power: float, rotation_vector: Vector3)

## Passthrough Signals
# From Agent
signal on_drive(linear: float, angular: float)
signal on_aim(pan: float, tilt: float)
signal on_scan(pan: float)
signal on_shoot(power: float)

# To Agent
signal on_drive_speed_changed(linear_speed: float, angular_speed: float)
signal on_turret_angle_changed(pan: float, tilt: float)
signal on_turret_speed_changed(pan_speed: float, tilt_speed: float)
signal on_scanner_angle_changed(scanner_rotation: float)
signal on_scanner_speed_changed(pan_speed: float)
signal on_wobble(roll: float, pitch: float, y: float)
signal on_cannon_heat_changed(heat: float)
signal on_reloaded_changed(reloaded: bool)
signal on_overheated_changed(overheated: bool)
signal on_tank_scanned(scan_position: Vector3, id: String)
signal on_obstacle_scanned(scan_position: Vector3)
signal on_nothing_scanned
