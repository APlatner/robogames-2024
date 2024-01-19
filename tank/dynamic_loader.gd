extends Node3D

## Load scripts into inherited .blend file then kill self.

func _enter_tree() -> void:
	dynamic_script_load()
	queue_free()


func dynamic_script_load() -> void:
	var root_path := "Roll/Pitch/Mesh/Chassis/"
	var roller_script := load("res://tank/physics_objects/roller.gd")
	var suspension_script := load("res://tank/physics_objects/suspension_arm.gd")
	var shock_script := load("res://tank/physics_objects/shock.gd")
	var cannon_script := load("res://tank/cannon/cannon.gd")
	var cannon_report_scene := load("res://tank/cannon/cannon_report.tscn") as PackedScene
	var engine_smoke_scene := load("res://tank/engine_smoke.tscn") as PackedScene
	var node: Node3D

	# Load roller scripts
	node = get_parent().get_node(root_path + "LeftFrontDriver") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.3
	node = get_parent().get_node(root_path + "LeftFrontSuspensionArm/LeftFrontIdler") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.3
	node = get_parent().get_node(root_path + "LeftRearSuspensionArm/LeftRearIdler") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.25
	node = get_parent().get_node(root_path + "LeftRearDriver") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.25

	node = get_parent().get_node(root_path + "RightFrontDriver") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.3
	node = get_parent().get_node(root_path + "RightFrontSuspensionArm/RightFrontIdler") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.3
	node = get_parent().get_node(root_path + "RightRearSuspensionArm/RightRearIdler") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.25
	node = get_parent().get_node(root_path + "RightRearDriver") as Node3D
	node.set_script(roller_script)
	(node as Roller).radius = 0.25

	# Load Suspension Arm Scripts
	node = get_parent().get_node(root_path + "LeftFrontSuspensionArm") as Node3D
	node.set_script(suspension_script)
	(node as SuspensionArm).side = SuspensionArm.Direction.FRONT
	#(node as SuspensionArm).offset = Vector3(0, 0.39, -0.4)

	node = get_parent().get_node(root_path + "LeftRearSuspensionArm") as Node3D
	node.set_script(suspension_script)

	node = get_parent().get_node(root_path + "RightFrontSuspensionArm") as Node3D
	node.set_script(suspension_script)
	(node as SuspensionArm).side = SuspensionArm.Direction.FRONT
	#(node as SuspensionArm).offset = Vector3(0, 0.39, -0.4)

	node = get_parent().get_node(root_path + "RightRearSuspensionArm") as Node3D
	node.set_script(suspension_script)

	# Load Shock Scripts
	node = get_parent().get_node(root_path + "LeftFrontShock") as Node3D
	node.set_script(shock_script)

	node = get_parent().get_node(root_path + "LeftRearShock") as Node3D
	node.set_script(shock_script)

	node = get_parent().get_node(root_path + "RightFrontShock") as Node3D
	node.set_script(shock_script)

	node = get_parent().get_node(root_path + "RightRearShock") as Node3D
	node.set_script(shock_script)

	# Load Cannon script
	node = get_parent().get_node(root_path + "TurretDriveKey/Turret/Barrel") as Node3D
	node.set_script(cannon_script)
	(node as Cannon)._local_signal_bus = get_parent().get_node("LocalSignalBus") as LocalSignalBus
	var cannon_report := cannon_report_scene.instantiate() as CannonReport
	cannon_report._local_signal_bus = get_parent().get_node("LocalSignalBus") as LocalSignalBus
	node.add_child(cannon_report)
	cannon_report.position = (node as Cannon).fire_offset

	# Load Smoke Scene
	node = get_parent().get_node(root_path) as Node3D
	var engine_smoke_instance := engine_smoke_scene.instantiate() as EngineSmoke
	node.add_child(engine_smoke_instance)
	engine_smoke_instance.position = Vector3(0.173, 1.418, -1.58)
	engine_smoke_instance = engine_smoke_scene.instantiate() as EngineSmoke
	node.add_child(engine_smoke_instance)
	engine_smoke_instance.position = Vector3(-0.173, 1.418, -1.58)
