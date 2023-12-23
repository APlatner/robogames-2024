@tool # optional
class_name Style
extends Node
## doc string

signal event_happened # signals are named as past-tense

enum State {
	RUNNING,
	STOPPED,
}

const MAX_SPEED: float = 10
@export var target_speed: float = 5
var public_var: int = 2
var _private_or_protected_var := false
@onready var parent: Node = get_parent()

func _init() -> void:
	pass


func _enter_tree() -> void:
	pass


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass


func public_method():
	pass


func _protected_method():
	pass


func _private_method():
	pass


func _on_signal_emitted():
	pass
