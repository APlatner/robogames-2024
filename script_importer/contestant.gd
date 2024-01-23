class_name Contestant
extends Resource

var compiled_script: Script
var script_path: String
var author: String
var agent_name: String
var number: int
@export var lines: Array[String]
@export var errors: Array[String]
@export var compile_error: int


func compile():
	var instance := compiled_script.new() as Agent
	(instance as Agent).start()
	author = (instance as Agent).author
	agent_name = (instance as Agent).agent_name

