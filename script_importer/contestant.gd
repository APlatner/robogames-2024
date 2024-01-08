class_name Contestant
extends Resource

var compiled_script
var _author: String
@export var lines: Array[String]
@export var errors: Array[String]
@export var compile_error: int


func compile():
	var instance = compiled_script.new()
	if instance.has("author"):
		_author = instance.author
