class_name SpawnManager

# Dictionary of Node arrays for individual spawn types, keyed by integer
var spawnDictionary = {}
var parent: Node2D

func initialise(owner: Node2D):
	parent = owner
	
	createSpawnPool(Enums.UnitType.PLAYER, 1, Constants.SCENE_PLAYER, "Player")
	createSpawnPool(Enums.UnitType.GRUNT, Constants.SPAWN_MAX_GRUNTS, Constants.SCENE_GRUNT, "Grunt")
	createSpawnPool(Enums.UnitType.HULK, Constants.SPAWN_MAX_HULKS, Constants.SCENE_HULK, "Hulk")
	createSpawnPool(Enums.UnitType.ELECTRODE, Constants.SPAWN_MAX_ELECTRODES, Constants.SCENE_ELECTRODE, "Electrode")
	createSpawnPool(Enums.UnitType.SPHEROID, Constants.SPAWN_MAX_SPHEROIDS, Constants.SCENE_SPHEROID, "Spheroid")
	createSpawnPool(Enums.UnitType.ENFORCER, Constants.SPAWN_MAX_ENFORCERS, Constants.SCENE_ENFORCER, "Enforcer")
	createSpawnPool(Enums.UnitType.ENFORCER_BULLET, Constants.SPAWN_MAX_ENFORCER_BULLETS, Constants.SCENE_ENFORCER_BULLET, "EnforcerBullet")
	createSpawnPool(Enums.UnitType.FAMILY, Constants.SPAWN_MAX_FAMILY, Constants.SCENE_FAMILY, "Family")

func createSpawnPool(key:int, numSpawns:int, resourcePath:String, friendlyName:String) -> void:
	# TODO: Check that the key doesn't already exist in the spawnDictionary
	var spawnScene = load(resourcePath)

	var spawnArray = []
	spawnArray.resize(numSpawns)
	var format_string = "%s_%d"
	for i in numSpawns:
		var spawn = spawnScene.instantiate()
		assert(spawn != null)

		spawn.set_name(format_string % [friendlyName, i])
		disableAndHideNode(spawn)
		spawnArray[i] = spawn
	
	spawnDictionary[key] = spawnArray


func disableAndHideNodeDeferred(node:Node) -> void:
	node.call_deferred("set_process_mode", Node.PROCESS_MODE_DISABLED)
	node.hide()
	if node.get_parent() != null:
		parent.remove_child(node)
	


func disableAndHideNode(node:Node) -> void:
	node.process_mode = Node.PROCESS_MODE_DISABLED
	node.hide()
	if node.get_parent() != null:
		parent.remove_child(node)
	
	
func enableAndShowNode(node:Node) -> void:
	node.process_mode = Node.PROCESS_MODE_INHERIT
	node.show()
	
	
func getAvailableNode(key:int) -> Node:
	var spawnArray = spawnDictionary[key]
	for i in spawnArray:
		if i.process_mode == Node.PROCESS_MODE_DISABLED:
			enableAndShowNode(i)
			return i
	
	return null


func getNodeByIndex(key:int, index:int) -> Node:
	var spawnArray = spawnDictionary[key]
	return spawnArray[index]
