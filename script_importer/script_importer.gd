extends Node

signal scripts_processed(scripts: Array[Contestant])
signal on_start(contestants: Array[Contestant])

var _file_names: Array[String]
var _dir_name: String
var _contestants: Array[Contestant]

## TODO: Get folder name and find all scripts within
## TODO: Load each script, if it has syntax errors, flag it. Else, load it as a contestant
func _import():
	for file_name in _file_names:
		var file = FileAccess.open(_dir_name + "/" + file_name, FileAccess.READ)
		if file:
			var contents: Array[String] = []
			while not file.eof_reached():
				contents.append(file.get_line())
			#_validate(contents)
			var contestant = Contestant.new()
			var script := load(_dir_name + "/" + file_name) as Script
			contestant.compile_error = script.reload()
			contestant.script_path = _dir_name + "/" + file_name
			if contestant.compile_error == 0:
				contestant.compiled_script = script
				contestant.compile()
			_contestants.append(contestant)
		else:
			print(FileAccess.get_open_error())
	scripts_processed.emit(_contestants)


func _validate(contents: Array[String]):
	var illegal_symbols: Array[String] = [
		"get_node",
		"get_parent",
		"get_parent_node_3d",
		"get_child",
		"OS"
	]

	var regex = RegEx.new()
	var search_string: String = "(?<!\\w)("
	for i in len(illegal_symbols):
		search_string += illegal_symbols[i] + ("|" if i < len(illegal_symbols) - 1 else "")
	search_string += ")(?!\\w)"
	print(search_string)
	regex.compile(search_string)
	for i in len(contents):
		var matches := regex.search_all(contents[i])
		for group in matches:
			print(
				"Illegal symbol '",
				group.get_string(),
				"' on (",
				i + 1,
				": ",
				group.get_start(),
				")"
			)



func _on_dir_selected(dir: String):
	_dir_name = dir
	var dir_obj = DirAccess.open(dir)
	if dir_obj:
		dir_obj.list_dir_begin()
		var file_name = dir_obj.get_next()
		while file_name != "":
			if not dir_obj.current_is_dir():
				_file_names.append(file_name)
			file_name = dir_obj.get_next()
		_import()
	else:
		print("An error occurred when trying to access the path.")


func _on_start_pressed() -> void:
	on_start.emit(_contestants)
	queue_free()
