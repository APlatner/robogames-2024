class_name CaterpillarTrackCurve
extends Path3D

@export_enum("Left", "Right") var _side: String = "Left"

var _rollers: Array[Wheel]
var q: float = 0.5 # Droop amount across upper rollers
var _radii: Array[float] # Array of wheel radii

func _ready() -> void:
	curve = Curve3D.new()
	_initialize_rollers()
	for roller in _rollers:
		_radii.append(roller._radius)
	_generate_curve_points()


func _process(_delta: float) -> void:
	_generate_curve_points()


func _generate_curve_points():
	curve.clear_points()
	var p: Array[Vector3] = []
	var l: Array[Vector3] = [] # Array of roller offset vectors
	var alpha: Array[float] = []
	var beta: Array[float] = []
	var u: Array[Vector3] = [] # First point on roller
	var v: Array[Vector3] = [] # Second point on roller
	var n: Array[float] = []
	var k: Array[float] = [] # Scalar length of tangent handles on circular bezier segments
	var f: Array[Vector3] = []# Outgoing tangent handles
	var g: Array[Vector3] = []# Incoming tangent handles
	var i_next: int
	var i_prev: int

	for i in len(_rollers):
		i_next = wrapi(i + 1, 0, 4)
		i_prev = wrapi(i - 1, 0, 4)
		p.append(to_local(_rollers[i].global_position))
		l.append(to_local(_rollers[i].global_position) - to_local(_rollers[i_next].global_position))
		l[i].x = 0

		alpha.append(
			acos(
				(_radii[i] - _radii[i_next]) / l[i].length()
			)
		)
		beta.append(atan2(l[i].y, l[i].z))

	for i in 4:
		i_next = wrapi(i + 1, 0, 4) # i + 1 wrapped around
		i_prev = wrapi(i - 1, 0, 4) # i - 1 wrapped around
		u.append(
			_radii[i] * Vector3(
				0,
				sin(beta[i_prev] + alpha[i_prev] - (q if i == 0 else 0.0)),
				cos(beta[i_prev] + alpha[i_prev] - (q if i == 0 else 0.0))
			)
		)
		v.append(
			_radii[i] * Vector3(
				0,
				sin(beta[i] + alpha[i] + (q if i == 3 else 0.0)),
				cos(beta[i] + alpha[i] + (q if i == 3 else 0.0))
			)
		)
		n.append(
			2 * PI / (
				fmod(beta[i_prev] + alpha[i_prev], 2 * PI)
				- fmod(beta[i] + alpha[i], 2 * PI)
				- (2 * PI if i == 1 else 0.0)
				- (q if i == 0 or i == 3 else 0.0)
				)
		)
		k.append(4.0 / 3.0 * tan(PI / 2 / n[i]))
		f.append(k[i] * Vector3(0, -u[i].z, u[i].y))
		g.append(k[i] * Vector3(0, v[i].z, -v[i].y))

		curve.add_point(u[i] + p[i], Vector3.ZERO, f[i])
		curve.add_point(v[i] + p[i], g[i])

	# Add droop segment and connect to start
	var s: float = 4 * sqrt(q)
	var h1: Vector3 = -s * f[0]
	var h4: Vector3 = -s * g[3]
	curve.set_point_out(curve.point_count - 1, h4)
	curve.add_point(u[0] + p[0], h1)


func _initialize_rollers():
	_rollers.append(get_parent().get_node(
		"Roll/Pitch/Chassis/"
		+ _side
		+ "RearDriver"
	))
	_rollers.append(get_parent().get_node(
		"Roll/Pitch/Chassis/"
		+ _side
		+ "RearSuspensionArm/"
		+ _side
		+ "RearIdler"
	))
	_rollers.append(get_parent().get_node(
		"Roll/Pitch/Chassis/"
		+ _side
		+ "FrontSuspensionArm/"
		+ _side
		+ "FrontIdler"
	))
	_rollers.append(get_parent().get_node(
		"Roll/Pitch/Chassis/"
		+ _side
		+ "FrontDriver"
	))
