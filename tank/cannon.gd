class_name Cannon
extends Node3D

const HEAT_DISSIPATION_RATE: float = 0.3
const HEAT_PER_SHOT: float = 0.25
const SHOTS_PER_SECOND: float = 5



var _heat: float = 0:
	set(value):
		_heat = value
		_local_signal_bus.cannon_heat_changed.emit(value)

var _overheated := false:
	set(value):
		_overheated = value
		_local_signal_bus.overheated_changed.emit(value)

var _reloaded := true:
	set(value):
		_reloaded = value
		_local_signal_bus.reloaded_changed.emit(value)

var _can_shoot := false:
	set(value):
		_can_shoot = value
		_local_signal_bus.cannon_heat_changed.emit(value)

var _time_since_last_shot: float = 0

var _bullet_instance: PackedScene = preload('res://tank/bullet.tscn')
var _parent_velocity: Vector3
var _local_signal_bus: LocalSignalBus

var fire_offset := Vector3(0, 0, 1)
var root_node: Node3D

func _enter_tree() -> void:
	_local_signal_bus.shoot_called.connect(_on_shoot_called)
	_local_signal_bus.velocity_changed.connect(_on_velocity_changed)


func _process(delta: float) -> void:
	if _heat >= 1:
		_overheated = true

	_heat -= delta * HEAT_DISSIPATION_RATE

	if _heat <= 0:
		_overheated = false

	_heat = clampf(_heat, 0, 1)

	_time_since_last_shot += delta * SHOTS_PER_SECOND
	if _time_since_last_shot >= 1:
		_reloaded = true
	_time_since_last_shot = clampf(_time_since_last_shot, 0, 1)

	if _can_shoot and (not _reloaded or _overheated):
		_can_shoot = false
	elif not _can_shoot and _reloaded and not _overheated:
		_can_shoot = true


## Callback to shoot from control script
func _on_shoot_called(power: float) -> void:
	if _can_shoot:
		var bullet := _bullet_instance.instantiate() as Bullet
		bullet.position = to_global(fire_offset)
		bullet.basis = Basis.looking_at(global_basis.z, Vector3.UP, true)
		bullet.initial_speed = 10 / pow(power, 0.35)
		bullet.parent_velocity = _parent_velocity
		bullet.visual_size = pow(power, 0.35) * Vector3.ONE
		get_tree().root.add_child(bullet)
		_local_signal_bus.cannon_fired.emit(
			power,
			get_parent_node_3d().get_parent_node_3d().rotation.y,
			rotation.x
		)
		_heat += HEAT_PER_SHOT
		_reloaded = false
		_time_since_last_shot = 0


func _on_velocity_changed(velocity: Vector3):
	_parent_velocity = velocity
