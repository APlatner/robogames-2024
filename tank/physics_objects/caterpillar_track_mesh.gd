extends MultiMeshInstance3D

@export var _tolerance: float = 0.002
var _local_signal_bus: LocalSignalBus

var _offset: float = 0
var _previous_offset: float = -1
var _linear_speed: float = 0
var _angular_speed: float = 0
var _instance_spacing: float = 0.215
var _derivative_bias: float = 0.4

@onready var _path: CaterpillarTrackCurve = get_child(0) as CaterpillarTrackCurve


func _enter_tree() -> void:
	_local_signal_bus = get_parent().get_node("LocalSignalBus") as LocalSignalBus
	var mesh = preload("res://blender/tread.obj")
	multimesh = MultiMesh.new()
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.mesh = mesh
	#multimesh.mesh.resource_path = "res://blender/tread.obj"


func _ready() -> void:
	_local_signal_bus.caterpillar_tracks_updated.connect(_on_track_updated)
	_local_signal_bus.on_drive_speed_changed.connect(func(linear_speed: float, angular_speed: float):
		_linear_speed = linear_speed
		_angular_speed = angular_speed
	)
	#_local_signal_bus.angular_speed_changed.connect(_on_angular_speed_changed)
	multimesh.instance_count = floori(_path.curve.get_baked_length() / _instance_spacing)


func _physics_process(delta: float) -> void:
	_offset -= delta * (_linear_speed - position.x * _angular_speed)
	if absf(_offset - _previous_offset) > _tolerance:
		_previous_offset = _offset
		_update_segment_positions()


func _update_segment_positions() -> void:
	var next_position: Vector3
	var previous_position: Vector3
	_offset = wrapf(_offset, 0, _path.curve.get_baked_length())
	for i in multimesh.instance_count:
		var i_next: int = wrapi(i + 1, 0, multimesh.instance_count)

		if i == 0:
			var i_prev: int = wrapi(i - 1, 0, multimesh.instance_count)
			previous_position = (
				_path.curve.sample_baked(wrapf(
					_offset
					+ float(i_prev) * _path.curve.get_baked_length() / multimesh.instance_count, 0, _path.curve.get_baked_length())
					))

		var instance_position := (
			_path.curve.sample_baked(wrapf(
				_offset
				+ float(i) * _path.curve.get_baked_length() / multimesh.instance_count, 0, _path.curve.get_baked_length())
				)
			if i == 0 else next_position)
		var next_instance_offset := float(i_next) * _path.curve.get_baked_length() / multimesh.instance_count

		next_position = _path.curve.sample_baked(
			wrapf(
				_offset
				+ next_instance_offset, 0, _path.curve.get_baked_length()
				)
			)
		var instance_basis := Basis()

		var derivative: Vector3 = (
				previous_position.direction_to(instance_position) * _derivative_bias
				+instance_position.direction_to(next_position) * (1 - _derivative_bias)
			)
		instance_basis.z = derivative
		instance_basis.x = transform.basis.x
		instance_basis.y = -instance_basis.x.cross(instance_basis.z)
		instance_basis = instance_basis.orthonormalized()
		multimesh.set_instance_transform(i, Transform3D(instance_basis, instance_position))

		previous_position = instance_position


func _on_track_updated() -> void:
	_previous_offset = _offset
	_update_segment_positions()


#func _on_linear_speed_changed(speed: float) -> void:
	#_linear_speed = speed
#
#
#func _on_angular_speed_changed(speed: float) -> void:
	#_angular_speed = speed
