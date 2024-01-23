extends Node

## TODO: Take in an array of contestants, instantiate arena, instantiate tanks with appropriate contestant scripts
var _arena_scene := load("res://arena/arena_test_01142024.tscn") as PackedScene
var _tank_scene := load("res://tank/tank.tscn") as PackedScene


func load_arena(contestants: Array[Contestant]):
	var arena_instance := _arena_scene.instantiate()
	add_child(arena_instance)
	print("arena_instance added as child")
	#await arena_instance.ready
	print("arena_instance entered tree")
	var spawnpoints := get_tree().get_nodes_in_group("spawnpoints")
	if len(spawnpoints) >= len(contestants):
		for i in len(contestants):
			var tank_instance := _tank_scene.instantiate() as Tank
			tank_instance._agent_script = contestants[i].script_path
			arena_instance.get_node("Agents").add_child(tank_instance)
			tank_instance.global_position = spawnpoints[i].global_position
			tank_instance.global_basis = spawnpoints[i].global_basis
