class_name ConfirmMenu
extends Control

signal confirmed
signal canceled

@export var _prompt: String
@export var _confirm_text: String
@export var _cancel_text: String

func _enter_tree() -> void:
	($CenterContainer/VBoxContainer/MarginContainer/Prompt
		as Label).text = _prompt
	($CenterContainer/VBoxContainer/HBoxContainer/ConfirmMargin/Confirm
		as Button).text = _confirm_text
	($CenterContainer/VBoxContainer/HBoxContainer/CancelMargin/Cancel
		as Button).text = _cancel_text

func _on_confirm_pressed() -> void:
	confirmed.emit()


func _on_cancel_pressed() -> void:
	canceled.emit()
