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

signal cannon_fired(power: float, turret_angle: float, barrel_angle: float)

signal drive_called(linear: float, angular: float)
signal aim_called(pan: float, tilt: float)
signal scan_called(pan: float)
signal shoot_called(power: float)
