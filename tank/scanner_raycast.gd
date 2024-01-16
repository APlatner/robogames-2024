extends RayCast3D

@export var _scan_distance: float = 50
var _local_signal_bus: LocalSignalBus

var _turret_angle: float
var _scanner_angle: float

func _enter_tree() -> void:
	_local_signal_bus = get_parent().get_node("LocalSignalBus") as LocalSignalBus
	target_position = Vector3.BACK * _scan_distance
	_local_signal_bus.turret_rotated.connect(_on_turret_rotated)
	_local_signal_bus.scanner_rotated.connect(_on_scanner_rotated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_colliding():
		var obj = get_collider()
		if obj is Tank:
			_local_signal_bus.enemy_scanned.emit(_local_signal_bus.to_local(get_collision_point()))
		else:
			_local_signal_bus.obstacle_scanned.emit(_local_signal_bus.to_local(get_collision_point()))


func _on_turret_rotated(turret_rotation: float) -> void:
	_turret_angle = turret_rotation
	rotation.y = _turret_angle + _scanner_angle + PI/2


func _on_scanner_rotated(scanner_rotation: float) -> void:
	_scanner_angle = scanner_rotation
	rotation.y = _turret_angle + _scanner_angle + PI/2
