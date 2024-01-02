extends Node3D

## Load scripts into inherited .blend file then kill self.

func _enter_tree() -> void:
	dynamic_script_load()
	queue_free()


func dynamic_script_load() -> void:
	var root_path := "Roll/Pitch/Mesh/Chassis/"
	var roller_script := load("res://tank/roller.gd")
	var suspension_script := load("res://tank/suspension_arm.gd")
	var shock_script := load("res://tank/shock.gd")
	var cannon_script := load("res://tank/cannon.gd")
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
	(node as Cannon).root_node = get_parent_node_3d()
	(node as Cannon).bullet_shot.connect(
		(get_parent().get_node("Roll") as PhysicsResponse)._on_shoot
	)
