extends MultiMeshInstance3D

@onready var path3d: Path3D = get_parent().get_node('Path3D')

var offset :float= 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var curve_space: float = 1.2
	offset += delta * 2
	var count = floori(path3d.curve.get_baked_length() / curve_space)
	multimesh.instance_count = count

	for i in count:
		var curve_distance = float(i) * path3d.curve.get_baked_length() / count
		var position = path3d.curve.sample_baked(fmod(curve_distance + offset, path3d.curve.get_baked_length()))

		var basis := Basis()
		basis.y = path3d.curve.sample_baked_up_vector(fmod(curve_distance + offset, path3d.curve.get_baked_length())) * 0.3
		basis.z = position.direction_to(path3d.curve.sample_baked(fmod(curve_distance + offset + 0.1, path3d.curve.get_baked_length()), true))
		basis.x = basis.z.cross(basis.y).normalized()
		var tr := Transform3D(basis, position)
		multimesh.set_instance_transform(i, tr)
