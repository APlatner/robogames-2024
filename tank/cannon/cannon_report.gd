class_name CannonReport
extends AudioStreamPlayer3D

@export var _local_signal_bus: LocalSignalBus
@export var _pitch_range: float = 0.2

var _shooting := false

@onready var _explosion_particle_node := get_node("GPUParticles3D") as GPUParticles3D

func _enter_tree() -> void:
	_local_signal_bus.cannon_fired.connect(_on_shoot)

func _ready() -> void:
	_explosion_particle_node.amount_ratio = 0


func _process(_delta: float) -> void:
	if not _shooting:
		_explosion_particle_node.amount_ratio = 0

	if _shooting:
		_shooting = false



func _on_shoot(_power, _turret_angle, _barrel_angle):
	pitch_scale = (randf() * 2 - 1) * _pitch_range + 1
	_explosion_particle_node.amount_ratio = 1
	_shooting = true
	play()
