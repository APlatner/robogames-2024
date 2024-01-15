class_name Controller
extends Node3D

var _local_signal_bus: LocalSignalBus

var player_name: String
var tank_name: String

var linear_speed: float = 0.0
var angular_speed: float = 0.0

## tank chassis
var chassis_rotation: float = 0.0
var chassis_pitch: float = 0.0
var chassis_roll: float = 0.0
var chassis_height: float = 0.0

## tank turret speed
var barrel_speed: float = 0.0

## tank turret
var turret_rotation: Vector2 = Vector2.ZERO

## tank shot
var shot_power: float = 1.0
var reloaded: bool = false
var overheated: bool = false
var can_shoot: bool = false
var cannon_heat: float = 0.0

var target_location: Vector3 = Vector3.ZERO
var target_id: int = 0

## drive tank, directions are floats ranging from 1.0 to -1.0
func drive(linear_direction: float, angular_direction: float) -> void:
	_local_signal_bus.drive_called.emit(linear_direction, angular_direction)

## aim turret towards target, tilt is used to account for bullet drop
func aim(pan: float, tilt: float) -> void:
	_local_signal_bus.aim_called.emit(pan, tilt)

## scan for other tanks
func scan(pan_speed: float) -> void:
	_local_signal_bus.scan_called.emit(pan_speed)

## shoot turret
func shoot(power: float) -> void:
	_local_signal_bus.shoot_called.emit(power)

func _enter_tree() -> void:
	_local_signal_bus = (get_parent() as Tank)._local_signal_bus as LocalSignalBus
	_local_signal_bus.connect("linear_speed_changed", _on_linear_speed_changed)
	_local_signal_bus.connect("angular_speed_changed", _on_angular_speed_changed)
	_local_signal_bus.connect("physics_elements_updated", _on_physics_elements_updated)
	_local_signal_bus.connect("barrel_end_of_travel", _on_barrel_end_of_travel)
	_local_signal_bus.connect("cannon_fired", _on_cannon_fired)
	_local_signal_bus.connect("tank_rotation_changed", _on_tank_rotation_changed)
	_local_signal_bus.connect("turret_rotation_changed", _on_turret_rotation_changed)
	_local_signal_bus.connect("reloaded_changed", _on_reloaded_changed)
	_local_signal_bus.connect("overheated_changed", _on_overheated_changed)
	_local_signal_bus.connect("can_shoot_changed", _on_can_shoot_changed)
	_local_signal_bus.connect("cannon_heat_changed", _on_cannon_heat_changed)
	_local_signal_bus.connect("enemy_scanned", _on_enemy_scanned)
	_local_signal_bus.connect("obsticle_scanned", _on_obsticle_scanned)

func _on_linear_speed_changed(speed: float) -> void:
	linear_speed = speed

func _on_angular_speed_changed(speed: float) -> void:
	angular_speed = speed

func _on_physics_elements_updated(pitch: float, roll: float, y: float) -> void:
	chassis_pitch = pitch
	chassis_roll = roll
	chassis_height = y

func _on_barrel_end_of_travel(speed: float, angle: float) -> void:
	barrel_speed = speed
	turret_rotation.y = angle

func _on_cannon_fired(power: float, angle: float, pitch: float) -> void:
	shot_power = power
	turret_rotation.y = angle
	turret_rotation.x = pitch

func _on_tank_rotation_changed(angle: float) -> void:
	chassis_rotation = angle

func _on_turret_rotation_changed(angle: Vector2) -> void:
	turret_rotation = angle

func _on_reloaded_changed(value: bool) -> void:
	reloaded = value

func _on_overheated_changed(value: bool) -> void:
	overheated = value

func _on_can_shoot_changed(value: bool) -> void:
	can_shoot = value

func _on_cannon_heat_changed(value: float) -> void:
	cannon_heat = value

func _on_enemy_scanned(location: Vector3, id: int) -> void:
	target_location = location
	target_id = id

func _on_obsticle_scanned(location: Vector3) -> void:
	target_location = location
