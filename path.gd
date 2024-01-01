extends PathFollow3D

@export var _offset: float = 0

var is_set:=false

func _process(delta: float) -> void:
	if not is_set:
		progress_ratio = _offset
		is_set = true
	progress_ratio -= delta/8
