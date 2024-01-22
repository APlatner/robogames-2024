extends RayCast3D

@export var _scan_distance: float = 50
var _local_signal_bus: LocalSignalBus

var _turret_angle: float
var _scanner_angle: float

func _enter_tree() -> void:
	_local_signal_bus = get_parent().get_node("LocalSignalBus") as LocalSignalBus
	target_position = Vector3.BACK * _scan_distance
	_local_signal_bus.on_turret_angle_changed.connect(_on_turret_rotated)
	_local_signal_bus.on_scanner_angle_changed.connect(_on_scanner_rotated)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if is_colliding():
		var obj = get_collider()
		if obj is Tank:
			var _localized_position := get_parent_node_3d().to_local((obj as Tank).global_position) as Vector3
			_local_signal_bus.on_tank_scanned.emit(_localized_position, str(obj.get_instance_id()).md5_text())
		else:
			_local_signal_bus.on_obstacle_scanned.emit(get_parent_node_3d().to_local(get_collision_point()))
	else:
		_local_signal_bus.on_nothing_scanned.emit()


func _on_turret_rotated(pan_angle: float, _tilt_angle: float) -> void:
	_turret_angle = pan_angle
	rotation.y = _turret_angle + _scanner_angle


func _on_scanner_rotated(scanner_rotation: float) -> void:
	_scanner_angle = scanner_rotation
	rotation.y = _turret_angle + _scanner_angle
