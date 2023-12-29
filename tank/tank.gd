extends CharacterBody3D

@export var _linear_accel: float = 5
@export var _angular_accel: float = 5

@export var _suspension_links: Array[SuspensionArm]

@export var _engine_idle: AudioStream
@export var _engine_full_speed: AudioStream
@export var _engine_rev_up: AudioStream
@export var _engine_rev_down: AudioStream

const MAX_LINEAR_SPEED: float = 5
const MAX_ANGULAR_SPEED: float = 5

var _linear_speed: float
var _previous_linear_speed: float
var _angular_speed: float

var _current_accel: Vector2

var _pitch_angle: float
var _pitch_speed: float
var _pitch_accel: float
var _pitch_stiffness: float = 3
var _pitch_damping: float = 9

var _roll_angle: float
var _roll_speed: float
var _roll_accel: float
var _roll_stiffness: float = 3
var _roll_damping: float = 6

#enum EngineState {
#	IDLE,
#	REV_UP,
#	REV_DOWN,
#	FULL_SPEED,
#}

#var _left_engine_state = IDLE
#var _left_prev_engine_state = IDLE
#var _right_engine_state = IDLE
#var _right_prev_engine_state = IDLE

func _ready() -> void:
	$LeftAudioStreamPlayer3D.stream = _engine_idle
	$LeftRevAudioStreamPlayer3D.stream = _engine_rev_up
	$RightAudioStreamPlayer3D.stream = _engine_idle
	$RightRevAudioStreamPlayer3D.stream = _engine_rev_up

func _process(_delta: float) -> void:
	var left_audio = $LeftAudioStreamPlayer3D
	var left_rev_audio = $LeftRevAudioStreamPlayer3D
	var right_audio = $RightAudioStreamPlayer3D
	var right_rev_audio = $RightRevAudioStreamPlayer3D
	var forward_input = Input.get_axis("backward", "forward")
	var horizontal_input = Input.get_axis("left", "right")

	if forward_input == 0.0 and horizontal_input == 0.0:
		if left_audio.stream == _engine_full_speed and left_audio.playing:
			left_rev_audio.play()
			left_audio.stop()
			left_audio.stream = _engine_idle
		elif left_rev_audio.stream == _engine_rev_down and not left_rev_audio.playing:
			left_audio.play()
			left_rev_audio.stream = _engine_rev_up
		elif left_audio.stream == _engine_idle and not left_audio.playing:
			left_audio.play()
		if right_audio.stream == _engine_full_speed and right_audio.playing:
			right_rev_audio.play()
			right_audio.stop()
			right_audio.stream = _engine_idle
		elif right_rev_audio.stream == _engine_rev_down and not right_rev_audio.playing:
			right_audio.play()
			right_rev_audio.stream = _engine_rev_up
		elif right_audio.stream == _engine_idle and not right_audio.playing:
			right_audio.play()
	elif (forward_input != 0.0 and horizontal_input == 0.0) or (forward_input == 0.0 and horizontal_input != 0.0):
		if left_audio.stream == _engine_idle and left_audio.playing:
			left_rev_audio.play()
			left_audio.stop()
			left_audio.stream = _engine_full_speed
		elif left_rev_audio.stream == _engine_rev_up and not left_rev_audio.playing:
			left_audio.play()
			left_rev_audio.stream = _engine_rev_down
		elif left_audio.stream == _engine_full_speed and not left_audio.playing:
			left_audio.play()
		if right_audio.stream == _engine_idle and right_audio.playing:
			right_rev_audio.play()
			right_audio.stop()
			right_audio.stream = _engine_full_speed
		elif right_rev_audio.stream == _engine_rev_up and not right_rev_audio.playing:
			right_audio.play()
			right_rev_audio.stream = _engine_rev_down
		elif right_audio.stream == _engine_full_speed and not right_audio.playing:
			right_audio.play()
	elif forward_input != 0.0 and horizontal_input != 0.0:
		if left_audio.stream == _engine_full_speed and left_audio.playing:
			left_rev_audio.play()
			left_audio.stop()
			left_audio.stream = _engine_idle
		elif left_rev_audio.stream == _engine_rev_down and not left_rev_audio.playing:
			left_audio.play()
			left_rev_audio.stream = _engine_rev_up
		elif left_audio.stream == _engine_idle and not left_audio.playing:
			left_audio.play()
		if right_audio.stream == _engine_idle and right_audio.playing:
			right_rev_audio.play()
			right_audio.stop()
			right_audio.stream = _engine_full_speed
		elif right_rev_audio.stream == _engine_rev_up and not right_rev_audio.playing:
			right_audio.play()
			right_rev_audio.stream = _engine_rev_down
		elif right_audio.stream == _engine_full_speed and not right_audio.playing:
			right_audio.play()

func _physics_process(delta: float) -> void:
	var target_linear_speed = Input.get_axis('backward', 'forward') * MAX_LINEAR_SPEED
	var target_angular_speed = -Input.get_axis('left', 'right') * MAX_ANGULAR_SPEED

	_linear_speed = _handle_any_accel(_linear_speed, target_linear_speed, _linear_accel * delta, MAX_LINEAR_SPEED)
	_angular_speed = _handle_any_accel(_angular_speed, target_angular_speed, _angular_accel * delta, MAX_ANGULAR_SPEED)
	velocity = _linear_speed * global_basis.z
	rotate(transform.basis.y, _angular_speed * delta)
	_calc_accel()
	_handle_pitch(delta)
	_tilt()
	_previous_linear_speed = _linear_speed
	move_and_slide()

	_wheels_up()

func _wheels_up():
	for link in _suspension_links:
		link.handle_link_rotation(self, _pitch_angle)
		link._handle_spin(self)

	$LeftTreadInstancer.speed = _linear_speed - _angular_speed * 0.91 - _pitch_speed * 2.1
	$RightTreadInstancer.speed = _linear_speed + _angular_speed * 0.91


func _handle_pitch(delta: float):
	_pitch_accel = (
		-_pitch_angle * _pitch_stiffness * delta -
		_pitch_speed * _pitch_damping * delta +
		_current_accel.y * 2)
	_pitch_speed += _pitch_accel
	_pitch_angle += _pitch_speed

	_roll_accel = (
		-_roll_angle * _roll_stiffness * delta -
		_roll_speed * _roll_damping * delta +
		_current_accel.x / 55)
	_roll_speed += _roll_accel
	_roll_angle += _roll_speed


func _tilt():
	$Roll.rotation_degrees = Vector3(0, 0, _roll_angle)
	$Roll/Pitch.rotation_degrees = Vector3(_pitch_angle, 0, 0)


func _calc_accel():
	_current_accel.x = _linear_speed * _angular_speed
	_current_accel.y = (_previous_linear_speed - _linear_speed)


func _handle_any_accel(current_speed: float, target_speed: float, accel: float, max_speed: float) -> float:
	target_speed = clampf(target_speed, -max_speed, max_speed)
	if current_speed < target_speed:
		current_speed += accel
		if current_speed > target_speed:
			current_speed = target_speed
	elif current_speed > target_speed:
		current_speed -= accel
		if current_speed < target_speed:
			current_speed = target_speed
	return current_speed
