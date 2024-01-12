class_name LocalSignalBus
extends Node3D

signal caterpillar_tracks_updated
signal physics_elements_updated(pitch: float, roll: float, y: float)
signal linear_speed_changed(speed: float)
signal velocity_changed(velocity: Vector3)
signal angular_speed_changed(speed: float)
signal linear_accel_changed(accel: float)
signal angular_accel_changed(accel: float)
signal barrel_end_of_travel(barrel_speed: float, turret_angle: float)
signal tank_rotation_changed(angle: float)
signal turret_rotation_changed(angle: float)

signal cannon_fired(power: float, turret_angle: float, barrel_angle: float)
signal reloaded_changed(reloaded: bool)
signal overheated_changed(overheated: bool)
signal can_shoot_changed(can_shoot: bool)
signal cannon_heat_changed(cannon_heat: float)

signal drive_called(linear: float, angular: float)
signal aim_called(pan: float, tilt: float)
signal scan_called(pan: float)
signal shoot_called(power: float)
