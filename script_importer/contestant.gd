class_name Contestant
extends Resource

var compiled_script: Script
var _author: String
@export var lines: Array[String]
@export var errors: Array[String]
@export var compile_error: int


func compile():
	var instance := compiled_script.new() as Controller
	(instance as Controller)._begin()
	print((instance as Controller).author)
	print((instance as Controller).agent_name)

