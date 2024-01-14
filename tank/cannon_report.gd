extends AudioStreamPlayer3D

@export var _local_signal_bus: LocalSignalBus
@export var _pitch_range: float = 0.2

func _enter_tree() -> void:
	_local_signal_bus.cannon_fired.connect(_on_shoot)


func _on_shoot(_power, _turret_angle, _barrel_angle):
	pitch_scale = (randf() * 2 - 1) * _pitch_range + 1
	play()
