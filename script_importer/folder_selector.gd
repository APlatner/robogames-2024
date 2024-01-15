extends HBoxContainer

signal folder_selected(folder: String)

func _on_button_pressed() -> void:
	folder_selected.emit(($TextEdit as TextEdit).text)
