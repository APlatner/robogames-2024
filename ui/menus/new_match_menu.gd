class_name NewMatchMenuUI
extends Control

signal back_pressed
signal tournament_pressed
signal rumble_pressed

func _on_tournament_pressed() -> void:
	tournament_pressed.emit()


func _on_rumble_pressed() -> void:
	rumble_pressed.emit()


func _on_back_pressed() -> void:
	back_pressed.emit()
