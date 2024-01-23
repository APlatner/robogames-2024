extends ScrollContainer

@export var _script_line_item: PackedScene
@onready var _vbox := get_child(0) as VBoxContainer

func _on_scripts_processed(scripts: Array[Contestant]):
	var index: int = 1
	for script in scripts:
		script.number = index
		index += 1
		var instance := _script_line_item.instantiate()
		instance.set_agent_name(script.agent_name)
		instance.set_author(script.author)
		instance.set_number(script.number)
		_vbox.add_child(instance)
