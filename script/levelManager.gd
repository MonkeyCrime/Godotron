class_name LevelManager

var parent: Node2D
var spawnManager: SpawnManager

# Required for spacing units out over the screen
var screen_size: Vector2
var boundaryOffset: Vector2
var centre_raycast: RayCast2D
var spawn_list: Array

# The current level being played, as shown on the UI
var level_display:int = 0
# Index into the level data array
var level_index:int = 0
# The actual level data, driven from the level data json files
var level_data

var enemies_remaining:int = 0
# The number of active enforcer enemies visible on the screen
var enforcer_count:int = 0
# The number of active enforcer bullets visible on the screen
var enforcer_bullet_count:int = 0
# The starting family bonus
# TODO: Move to Constants
var family_bonus:int = 1000

func initialise(owner: Node2D, spawnMgr: SpawnManager, screensize: Vector2, raycast: RayCast2D) -> void:
	screen_size = screensize
	parent = owner
	centre_raycast = raycast
	spawnManager = spawnMgr
	
	Events.safe_connect(Constants.EVENT_ENEMY_HIT, on_enemy_hit)
	Events.safe_connect(Constants.EVENT_ENEMY_DEAD, on_enemy_dead)
	Events.safe_connect(Constants.EVENT_SPAWN_ENEMY, on_spawn_enemy)
	Events.safe_connect(Constants.EVENT_PLAYER_RESCUE_FAMILY, on_family_rescue)
	
	
func load_level_data(filename: StringName) -> void:
	var file = FileAccess.open(filename, FileAccess.READ)
	var content = file.get_as_text()
	level_data = JSON.parse_string(content)
	
	
func initialiseNextLevel(node:Node2D) -> void:
	# Level data consists of two json files. The first five levels are an intro
	# to the game. The second set of level data forms an endless series of waves
	# where individual enemy counts are incremented, up until the limits set in
	# the Config class are reached. Each wave in the second level set features
	# an increase in a certain enemy type e.g. a grunt wave, an electrode wave,
	# a hulk wave etc.
	# We use a modulus on the level_index variable to loop through the same five
	# levels, modifying as we go.
	
	# Level 5: grunt wave
	# Level 6: electrode wave
	# Level 7: hulk wave
	# Level 8: spheroid wave
	# Level 9: smash wave

	# Point to the right index in the level data
	level_index = level_display % 5
	enforcer_bullet_count = 0
	enforcer_count = 0

	if level_display == 0:
		# Starting the game, load the beginner level data
		load_level_data(Constants.LEVEL_STARTER)
	elif level_display == 5:
		# On wave 5, load the endless level data
		load_level_data(Constants.LEVEL_ENDLESS)
	
	if level_display > 10:
		adjust_level_difficulty()
	
	spawnUnits(node, Enums.UnitType.FAMILY, level_data[level_index].num_family)
	spawnUnits(node, Enums.UnitType.HULK, level_data[level_index].num_hulks)
	spawnUnits(node, Enums.UnitType.ELECTRODE, level_data[level_index].num_electrodes)
	enemies_remaining += spawnUnits(node, Enums.UnitType.GRUNT, level_data[level_index].num_grunts)
	enemies_remaining += spawnUnits(node, Enums.UnitType.SPHEROID, level_data[level_index].num_spheroids)
	spawnPlayer(node)
	
	level_display += 1
	
	
func spawnPlayer(node:Node2D) -> void:
	var player = spawnManager.getNodeByIndex(Enums.UnitType.PLAYER, 0)
	player.position.x = screen_size.x / 2
	player.position.y = screen_size.y / 2

	if player.get_parent() == null:
		node.add_child(player)


func spawnUnits(node:Node2D, unitType:Enums.UnitType, num_units:int) -> int:
	if num_units == 0:
		return 0
		
	var num_spawns = 0
	var player = spawnManager.getNodeByIndex(Enums.UnitType.PLAYER, 0)
	
	centre_raycast.position = Vector2(screen_size.x / 2, screen_size.y / 2)
	centre_raycast.rotation_degrees = 0
	centre_raycast.target_position.x = screen_size.x
	
	@warning_ignore("integer_division")
	var rotate_degrees:int = int(360 / num_units)
	@warning_ignore("integer_division")
	var step_variance:int = rotate_degrees / 2
	var current_rotation: int = 0
	
	for count in num_units:
		@warning_ignore("integer_division")
		centre_raycast.rotation_degrees = current_rotation + randi_range(-step_variance / 2, step_variance / 2)
		centre_raycast.force_raycast_update()
		if centre_raycast.is_colliding():
			var collision_point = centre_raycast.get_collision_point()
			
			var distance = randf_range(Constants.SPAWN_MIN_DISTANCE, Constants.SPAWN_MAX_DISTANCE)
			var pos = centre_raycast.position.lerp(collision_point, distance)
			
			var unit = spawnManager.getAvailableNode(unitType)
			assert(unit != null)
			if unit != null:
				num_spawns += 1
				unit.initialise({
					"pos" : pos,
					"player_node" : player,
					"level_data" : level_data[level_index]
				})

			# Only need to add the child and wire up once
			if unit.get_parent() == null:
				node.call_deferred("add_child", unit)

			unit.show()

			current_rotation += rotate_degrees
	
	return num_spawns


# Called when an enemy is hit by a projectile
func on_enemy_hit(node:EnemyBase):
	match node.unitType:
		Enums.UnitType.ENFORCER:
			enforcer_count -= 1
		Enums.UnitType.ENFORCER_BULLET:
			enforcer_bullet_count -= 1

	enemies_remaining -= 1
	print(node.name, " on_enemy_hit - enemies remaining: ", enemies_remaining)
	if enemies_remaining == 0:
		Events.emit_signal(Constants.EVENT_LEVEL_COMPLETE)


func on_enemy_dead(node:EnemyBase):
	# Need to call deferred to allow physics to finish processing
	spawnManager.disableAndHideNodeDeferred(node)


# Remove any remaining on-screen projectiles after the level is complete
func removeAllProjectiles(node:Node2D):
	var children = node.get_children()
	while not children.is_empty():
		var child = children.pop_back()
		if child.is_in_group("PlayerProjectiles"):
			child.queue_free()
		elif child.is_in_group("Enemies"):
			spawnManager.disableAndHideNodeDeferred(child)


func hide_player():
	var player = spawnManager.getNodeByIndex(Enums.UnitType.PLAYER, 0)
	spawnManager.disableAndHideNode(player)

func on_spawn_enemy(spawn_data:Dictionary):
	var add_to_enemy_count = true
	
	# Maximum unit count per level checks
	if spawn_data.unit_type == Enums.UnitType.ENFORCER && enforcer_count == Constants.SPAWN_MAX_ENFORCERS:
		print("max enforcer limit reached")
		return
		
	if spawn_data.unit_type == Enums.UnitType.ENFORCER_BULLET:
		add_to_enemy_count = false
		
		if enforcer_bullet_count == Constants.SPAWN_MAX_ENFORCER_BULLETS:
			print("max enforcer bullet limit reached")
			return
	
	var player = spawnManager.getNodeByIndex(Enums.UnitType.PLAYER, 0)
	var unit = spawnManager.getAvailableNode(spawn_data.unit_type)
	#assert(unit != null)

	# TODO: Consider whether this is worth reworking
	# The above call to getAvailableNode() can return null in some situations. Timing interaction
	# between events means that a unit can be hit (particularly enforcers), the max_enforcers count
	# is decremented, but the frame hasn't finished and the enemy hasn't been returned to the pool.  
	if unit == null:
		return
		
	if add_to_enemy_count:
		enemies_remaining += 1
	unit.add_to_group("Enemies")
	
	if spawn_data.unit_type == Enums.UnitType.ENFORCER:
		enforcer_count += 1
	
	#print("on_spawn_enemy - enemies remaining: ", enemies_remaining)
	unit.initialise({
		"pos" : spawn_data.pos,
		"player_node" : player,
		"level_data" : level_data[level_index]
	})

	# Only need to add the child and wire up once
	if unit.get_parent() == null:
		parent.call_deferred("add_child", unit)

	spawnManager.enableAndShowNode(unit)
	
	#print(unit.name, " spawned - enemies remaining: ", enemies_remaining)


func on_family_rescue(_node:Node2D):
	Events.emit_signal(Constants.EVENT_UI_UPDATE_POINTS, { "points" : family_bonus } )
	Events.emit_signal(Constants.EVENT_PLAYER_PLAY_BONUS, { 
		"points" : family_bonus,
		"node" : _node
	 } )
	
	family_bonus += 1000
	if family_bonus > 5000:
		Events.emit_signal(Constants.EVENT_PLAYER_ADD_LIVES, 1 )
		family_bonus = 1000
	
	
func adjust_level_difficulty():
	match level_index:
		0:	# grunt wave
			level_data[level_index].num_grunts += 4
			limit_grunts()
		1:	# electrode wave
			level_data[level_index].num_electrodes += 4
			limit_electrodes()
		2:	# hulk wave
			level_data[level_index].num_hulks += 4
			limit_hulks()
		3:	#spheroid wave
			level_data[level_index].num_spheroids += 2
			limit_spheroids()
		4:	# smash wave
			level_data[level_index].num_grunts += 4
			level_data[level_index].num_electrodes += 4
			level_data[level_index].num_hulks += 4
			level_data[level_index].num_spheroids += 2
			limit_grunts()
			limit_electrodes()
			limit_hulks()
			limit_spheroids()
	
	
func limit_grunts():
	if level_data[level_index].num_grunts > Constants.SPAWN_MAX_GRUNTS:
		level_data[level_index].num_grunts = Constants.SPAWN_MAX_GRUNTS
	
	
func limit_electrodes():
	if level_data[level_index].num_electrodes > Constants.SPAWN_MAX_ELECTRODES:
		level_data[level_index].num_electrodes = Constants.SPAWN_MAX_ELECTRODES
	
	
func limit_hulks():
	if level_data[level_index].num_hulks > Constants.SPAWN_MAX_HULKS:
		level_data[level_index].num_hulks = Constants.SPAWN_MAX_HULKS
	
	
func limit_spheroids():
	if level_data[level_index].num_spheroids > Constants.SPAWN_MAX_SPHEROIDS:
		level_data[level_index].num_spheroids = Constants.SPAWN_MAX_SPHEROIDS
