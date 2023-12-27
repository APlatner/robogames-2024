extends Path3D


@export var rear_driver: Wheel
@export var rear_idler: Wheel
@export var front_idler: Wheel
@export var front_driver: Wheel

var a: float = 0

func _ready() -> void:
	curve = Curve3D.new()
	_generate_curve_points()

func _process(delta: float) -> void:
	_generate_curve_points()
	#rear_idler.position.x += Input.get_axis('left', 'right') * delta * 2
	#rear_idler.position.y += Input.get_axis('backward', 'forward') * delta * 2
	#rotate_y(delta)


func _generate_curve_points():
	curve.clear_points()
	var l1 := to_local(rear_idler.global_position) - to_local(rear_driver.global_position)
	var l2 := to_local(front_idler.global_position) - to_local(rear_idler.global_position)
	var l3 := to_local(front_driver.global_position) - to_local(front_idler.global_position)
	var l4 := to_local(rear_driver.global_position) - to_local(front_driver.global_position)
	l1.x=0
	l2.x=0
	l3.x=0
	l4.x=0

	var a1 := acos((rear_driver._radius - rear_idler._radius) / l1.length())
	var b1 := atan2(l1.y, l1.z)

	var r1b := rear_driver._radius * Vector3(0, sin(b1 - a1),cos(b1 - a1))
	var r2a := rear_idler._radius * Vector3( 0,sin(b1 - a1),cos(b1 - a1))

	var p1b := to_local(rear_driver.global_position) + r1b
	var p2a := to_local(rear_idler.global_position) + r2a

	var a2 := acos((rear_idler._radius - front_idler._radius) / l2.length())
	var b2 := atan2(l2.y, l2.z)

	var r2b := rear_idler._radius * Vector3(0, sin(b2 - a2),cos(b2 - a2))
	var r3a := front_idler._radius * Vector3(0, sin(b2 - a2),cos(b2 - a2))

	var n2 := 2 * PI / ((b1 - a1) - (b2 - a2))
	var k2 := 4.0 / 3.0 * tan(PI / 2 / n2)

	var t2a := -Vector3(-r2a.y, r2a.z, 0) * k2
	var t2b := Vector3(-r2b.y, r2b.z, 0) * k2

	var p2b := to_local(rear_idler.global_position) + r2b
	var p3a := to_local(front_idler.global_position) + r3a

	var a3 := acos((front_idler._radius - front_idler._radius) / l3.length())
	var b3 := atan2(l3.y, l3.z)

	var r3b := front_idler._radius * Vector3(0, sin(b3 - a3),cos(b3 - a3))
	var r4a := front_driver._radius * Vector3(0,sin(b3 - a3),cos(b3 - a3))

	var n3 := 2 * PI / ((b2 - a2) - (b3 - a3))
	var k3 := 4.0 / 3.0 * tan(PI / 2 / n3)

	var t3a := -Vector3(0, r3a.z, -r3a.y) * k3
	var t3b := Vector3(0, r3b.z, -r3b.y) * k3

	var p3b := to_local(front_idler.global_position) + r3b
	var p4a := to_local(front_driver.global_position) + r4a

	#a = 0.3
	var b: float = -atan2(l4.z, l4.y)

	var s := 4 * sqrt(a)

	var g1 := to_local(rear_driver.global_position) + rear_driver._radius * Vector3(0,sin(b - a),cos(b - a))
	var g4 := to_local(front_driver.global_position) + front_driver._radius * Vector3(0, sin(b + a),cos(b + a))

	var g2 := Vector3(0, -(g1 - to_local(rear_driver.global_position)).z,(g1 - to_local(rear_driver.global_position)).y) * s
	var g3 := -Vector3(0, -(g4 - to_local(front_driver.global_position)).z,(g4 - to_local(front_driver.global_position)).y) * s

	var r4b := front_driver._radius * Vector3(0, sin(b + a),cos(b + a))
	var r1a := rear_driver._radius * Vector3(0, sin(b - a),cos(b - a))

	var n4: float = 2 * PI / abs((b3 - a3) - (b + a))
	var k4: float = 4.0 / 3.0 * tan(PI / 2 / n4)

	var t4a := -Vector3(0, -r4a.z, r4a.y) * k4
	var t4b := Vector3(0, -r4b.z, r4b.y) * k4

	var n1: float = 2 * PI / abs((2 * PI-a1+b1) - (b-a))
	var k1: float = 4.0 / 3.0 * tan(PI / 2 / n1)

	var t1a := Vector3(0, r1a.z, -r1a.y) * k1
	var t1b := -Vector3(0, r1b.z, -r1b.y) * k1

	curve.add_point(p1b)
	curve.add_point(p2a, Vector3.ZERO, t2a)
	curve.add_point(p2b, t2b)
	curve.add_point((p3a), Vector3.ZERO, t3a)
	curve.add_point((p3b), (t3b))
	curve.add_point((p4a), (Vector3.ZERO), (t4a))
	curve.add_point((g4), (t4b), (g3))
	curve.add_point((g1), (g2), (t1a))
	curve.add_point((p1b), (t1b))
	curve.set_point_tilt(0,0)
	curve.set_point_tilt(1,0)
	curve.set_point_tilt(2,0)
	curve.set_point_tilt(3,0)
	curve.set_point_tilt(4,0)
	curve.set_point_tilt(5,0)
	curve.set_point_tilt(6,0)
	curve.set_point_tilt(7,0)
	curve.set_point_tilt(8,0)
