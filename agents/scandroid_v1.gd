extends Agent


var _tank_scanned := false
var _previous_tank_scanned := false

var _last_scan_position: Vector3
var _ccw_bound: Vector3
var _cw_bound: Vector3

var _scan_sign: int = 1
var _scan_speed_scale: float = 1.2

var _time_since_last_scan: float = 0

var _buffer_size: int = 1
var _position_buffer: Array[Vector3]
var _cw_buffer: Array[Vector3]
var _ccw_buffer: Array[Vector3]
var _previous_scan_position: Vector3
var _averaged_scan_position: Vector3
var _velocity_adjusted_position: Vector3
var _filtered_position: Vector3

func start():
	_author = "Jonathan Platner"
	_tank_name = "Scandroid"
	_ccw_buffer.resize(_buffer_size)
	_ccw_buffer.fill(Vector3.ZERO)
	_cw_buffer.resize(_buffer_size)
	_cw_buffer.fill(Vector3.ZERO)

func run(delta: float):
	_time_since_last_scan += delta
	var distance := (_cw_bound/2+_ccw_bound/2).length()
	if distance > 0 and _time_since_last_scan < 0.5:
		scan(_scan_sign * _scan_speed_scale/distance)
	else:
		scan(0.5)

	if _previous_tank_scanned != _tank_scanned:
		_previous_tank_scanned = _tank_scanned
		if not _tank_scanned:
			_scan_sign *= -1

		if _scanner_pan_speed > 0 and _tank_scanned:
			_cw_bound = _last_scan_position
			_cw_buffer.push_front(_last_scan_position)
			_cw_buffer.pop_back()
			_update_buffers()
		elif _scanner_pan_speed > 0 and not _tank_scanned:
			_ccw_bound = _last_scan_position
			_ccw_buffer.push_front(_last_scan_position)
			_ccw_buffer.pop_back()
			_update_buffers()
		elif _scanner_pan_speed < 0 and _tank_scanned:
			_ccw_bound = _last_scan_position
			_ccw_buffer.push_front(_last_scan_position)
			_ccw_buffer.pop_back()
			_update_buffers()
		elif _scanner_pan_speed < 0 and not _tank_scanned:
			_cw_bound = _last_scan_position
			_cw_buffer.push_front(_last_scan_position)
			_cw_buffer.pop_back()
			_update_buffers()
	_filtered_position = _velocity_adjusted_position * 0.1 + _filtered_position * 0.9
	signal_bus.targeted.emit(_velocity_adjusted_position + Vector3.UP * 1.5)




func _update_buffers():
	var trunc_cw_buffer = _cw_buffer.filter(vec_not_zero)
	var trunc_ccw_buffer = _ccw_buffer.filter(vec_not_zero)
	if len(trunc_cw_buffer) > 0 and len(trunc_ccw_buffer) > 0:
		var cw_avg: Vector3 = trunc_cw_buffer.reduce(sum_vec_array)/len(trunc_cw_buffer)
		var ccw_avg: Vector3 = trunc_ccw_buffer.reduce(sum_vec_array)/len(trunc_ccw_buffer)
		_averaged_scan_position = (cw_avg + ccw_avg)/2
		var diff := _averaged_scan_position - _previous_scan_position
		_velocity_adjusted_position = _averaged_scan_position + diff * _buffer_size

		_previous_scan_position = _averaged_scan_position
	_time_since_last_scan = 0


func vec_not_zero(vector: Vector3) -> bool:
	return vector != Vector3.ZERO

func sum_vec_array(accum: Vector3, base: Vector3) -> Vector3:
	return accum + base


func _on_tank_scanned(scan_position: Vector3, _id: String):
	_last_scan_position = scan_position
	_tank_scanned = true


func _on_nothing_scanned():
	_tank_scanned = false


func _on_obstacle_scanned(_u: Vector3):
	_tank_scanned = false
