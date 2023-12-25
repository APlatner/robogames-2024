extends Path3D


@onready var wheel1 := get_node('Objects/Driver1') as Wheel
@onready var wheel2 := get_node('Objects/Idle2') as Wheel
@onready var wheel3 := get_node('Objects/Idle1') as Wheel
@onready var wheel4 := get_node('Objects/Driver2') as Wheel


func _ready() -> void:
	curve = Curve3D.new()
	_generate_curve_points()

func _process(delta: float) -> void:
	_generate_curve_points()
	wheel2.position.x += Input.get_axis('left', 'right') * delta * 2
	wheel2.position.y += Input.get_axis('backward', 'forward') * delta * 2
	rotate_y(delta)


func _generate_curve_points():
	curve.clear_points()
	var l1 := wheel2.position - wheel1.position
	var l2 := wheel3.position - wheel2.position
	var l3 := wheel4.position - wheel3.position
	var l4 := wheel1.position - wheel4.position

	var a1 := acos((wheel1._radius - wheel2._radius) / l1.length())
	var b1 := atan2(l1.y, l1.x)

	var r1b := wheel1._radius * Vector3(cos(b1 - a1), sin(b1 - a1), 0)
	var r2a := wheel2._radius * Vector3(cos(b1 - a1), sin(b1 - a1), 0)

	var p1b := wheel1.position + r1b
	var p2a := wheel2.position + r2a

	var a2 := acos((wheel2._radius - wheel3._radius) / l2.length())
	var b2 := atan2(l2.y, l2.x)

	var r2b := wheel2._radius * Vector3(cos(b2 - a2), sin(b2 - a2), 0)
	var r3a := wheel3._radius * Vector3(cos(b2 - a2), sin(b2 - a2), 0)

	var n2 := 2 * PI / ((b1 - a1) - (b2 - a2))
	var k2 := 4.0 / 3.0 * tan(PI / 2 / n2)

	var t2a := -Vector3(-r2a.y, r2a.x, 0) * k2
	var t2b := Vector3(-r2b.y, r2b.x, 0) * k2

	var p2b := wheel2.position + r2b
	var p3a := wheel3.position + r3a

	var a3 := acos((wheel3._radius - wheel3._radius) / l3.length())
	var b3 := atan2(l3.y, l3.x)

	var r3b := wheel3._radius * Vector3(cos(b3 - a3), sin(b3 - a3), 0)
	var r4a := wheel4._radius * Vector3(cos(b3 - a3), sin(b3 - a3), 0)

	var n3 := 2 * PI / ((b2 - a2) - (b3 - a3))
	var k3 := 4.0 / 3.0 * tan(PI / 2 / n3)

	var t3a := -Vector3(-r3a.y, r3a.x, 0) * k3
	var t3b := Vector3(-r3b.y, r3b.x, 0) * k3

	var p3b := wheel3.position + r3b
	var p4a := wheel4.position + r4a

	var a: float = 0.2
	var b: float = -atan2(l4.x, l4.y)

	var s := 4 * sqrt(a)

	var g1 := wheel1.position + wheel1._radius * Vector3(cos(b - a), sin(b - a), 0)
	var g4 := wheel4.position + wheel4._radius * Vector3(cos(b + a), sin(b + a), 0)

	var g2 := Vector3((g1 - wheel1.position).y, -(g1 - wheel1.position).x, 0) * s
	var g3 := -Vector3((g4 - wheel4.position).y, -(g4 - wheel4.position).x, 0) * s

	var r4b := wheel4._radius * Vector3(cos(b + a), sin(b + a), 0)
	var r1a := wheel1._radius * Vector3(cos(b - a), sin(b - a), 0)

	var n4: float = 2 * PI / abs((b3 - a3) - (b + a))
	var k4: float = 4.0 / 3.0 * tan(PI / 2 / n4)

	var t4a := Vector3(-r4a.y, r4a.x, 0) * k4
	var t4b := -Vector3(-r4b.y, r4b.x, 0) * k4

	var n1: float = 2 * PI / abs((2 * PI-a1+b1) - (b-a))
	var k1: float = 4.0 / 3.0 * tan(PI / 2 / n1)

	var t1a := Vector3(-r1a.y, r1a.x, 0) * k1
	var t1b := -Vector3(-r1b.y, r1b.x, 0) * k1

	curve.add_point(to_global(p1b))
	curve.add_point(to_global(p2a), to_global(Vector3.ZERO), to_global(t2a))
	curve.add_point(to_global(p2b), to_global(t2b))
	curve.add_point(to_global(p3a), to_global(Vector3.ZERO), to_global(t3a))
	curve.add_point(to_global(p3b), to_global(t3b))
	curve.add_point(to_global(p4a), to_global(Vector3.ZERO), to_global(t4a))
	curve.add_point(to_global(g4), to_global(t4b), to_global(g3))
	curve.add_point(to_global(g1), to_global(g2), to_global(t1a))
	curve.add_point(to_global(p1b), to_global(t1b))
