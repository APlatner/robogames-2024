extends Node3D

func _enter_tree() -> void:
	get_child(0).queue_free()


func _ready() -> void:
	#print(basis.z)
	pass
