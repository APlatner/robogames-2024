class_name MainMenu
extends Control

signal exit_pressed
signal new_match_pressed
signal load_match_pressed
signal settings_pressed


func _on_exit_pressed() -> void:
	exit_pressed.emit()


func _on_load_match_pressed() -> void:
	load_match_pressed.emit()


func _on_new_match_pressed() -> void:
	new_match_pressed.emit()


func _on_settings_pressed() -> void:
	settings_pressed.emit()
