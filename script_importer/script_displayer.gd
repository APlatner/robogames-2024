extends ScrollContainer

@export var _script_line_item: PackedScene
@onready var _vbox := get_child(0) as VBoxContainer

func _on_scripts_processed(scripts: Array[Contestant]):
	for script in scripts:
		var instance := _script_line_item.instantiate()
		_vbox.add_child(instance)
