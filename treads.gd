extends MultiMeshInstance3D

@export var path3d: Path3D

var offset :float= 0

var speed = 0

var count: int
var curve_space: float = 0.21

var count_set := false

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if not count_set:
		count = floori(path3d.curve.get_baked_length() / curve_space)
		count_set = true

	offset -= delta * speed
	multimesh.instance_count = count

	for i in count:
		var curve_distance = float(i) * path3d.curve.get_baked_length() / count
		var position = path3d.curve.sample_baked(fmod(curve_distance + offset, path3d.curve.get_baked_length()))

		var basis := Basis()

		while offset<0:
			offset+=path3d.curve.get_baked_length()

		basis.z = position.direction_to(path3d.curve.sample_baked(fposmod(curve_distance + offset + 0.1, path3d.curve.get_baked_length()), true))
		basis.x = transform.basis.x
		basis.y = -basis.x.cross(basis.z)
		basis = basis.orthonormalized()
		var tr := Transform3D(basis, position)
		multimesh.set_instance_transform(i, tr)
