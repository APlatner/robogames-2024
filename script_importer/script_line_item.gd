extends MarginContainer


func set_author(author: String):
	$HBoxContainer/VBoxContainer/Author.text = "by " + author

func set_agent_name(agent_name: String):
	$HBoxContainer/VBoxContainer/ScriptName.text = agent_name


func set_number(number: int):
	$HBoxContainer/NumberMargin/ScriptNumber.text = str(number).pad_zeros(2)
