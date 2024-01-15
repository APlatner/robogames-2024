extends Control

enum MenuState {
	MAIN,
	SETTINGS,
	EXIT,
	LOAD,
	NEW,
	TOURNAMENT,
	RUMBLE,
}

@export var _menu_transition_duration: float = 0.25
@export var _main_menu: Control
@export var _confirm_exit_menu: Control
@export var _new_match_menu: Control

var _state: MenuState = MenuState.MAIN
var _previous_state: MenuState = MenuState.MAIN

func _enter_tree() -> void:
	_confirm_exit_menu.position = Vector2(-get_viewport_rect().size.x, 0)
	_confirm_exit_menu.visible = true
	get_tree().get_root().size_changed.connect(_on_viewport_size_changed)


func _on_exit_pressed() -> void:
	_previous_state = _state
	_state = MenuState.EXIT
	_shift(_main_menu, _confirm_exit_menu, Vector2.LEFT)


func _on_confirm_exit() -> void:
	get_tree().quit()


func _on_cancel_exit() -> void:
	_previous_state = _state
	_state = MenuState.MAIN
	if _previous_state == MenuState.EXIT:
		_shift(_confirm_exit_menu, _main_menu, Vector2.RIGHT)


func _on_new_match_pressed() -> void:
	_previous_state = _state
	_state = MenuState.NEW
	if _previous_state == MenuState.MAIN:
		_shift(_main_menu, _new_match_menu, Vector2.RIGHT)


func _on_new_match_menu_back_pressed() -> void:
	_state = MenuState.NEW
	var intermediate := _state
	_state = _previous_state
	_previous_state = intermediate
	if _previous_state == MenuState.NEW:
		_shift(_new_match_menu, _main_menu, Vector2.LEFT)


func _shift(current: Control, next: Control, direction: Vector2) -> void:
	var viewport_size := get_viewport_rect().size
	var offset := Vector2(
		direction.x * viewport_size.x,
		direction.y * viewport_size.y
	)
	next.position = offset
	next.visible = true
	var current_tween := get_tree().create_tween()
	var next_tween := get_tree().create_tween()
	next_tween.tween_property(next, "position",
		Vector2.ZERO,
		_menu_transition_duration).set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_property(current, "position",
		-offset,
		_menu_transition_duration).set_trans(Tween.TRANS_CUBIC)
	pass


func _on_viewport_size_changed() -> void:
	pass
