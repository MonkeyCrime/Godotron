# hulk active.gd
extends State

var animation_player: AnimationPlayer
var player_node: Node2D
var walk_direction: Enums.Direction
var walk_timer: Timer


# Called when entering the Active state
func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	player_node = _msg.player_node
	
	create_timer()
	get_new_direction()
	
	
# Main loop
func update(_delta: float) -> void:
	var direction = Constants.WALK_DIRECTIONS[walk_direction]
	
	owner.velocity = Constants.SPEED_HULK * direction
	owner.move_and_slide()
	
	for i in owner.get_slide_collision_count():
		var collider = owner.get_slide_collision(i).get_collider()
		#print(owner.name, " hit by ", collider.name)
		if collider.is_in_group(Constants.GROUPNAME_WALLS):
			get_new_direction(true)
			break
		# Electrodes are static objects and can't detect collisions themselves,
		# so we need to tell them they've been hit
		elif collider.is_in_group(Constants.GROUPNAME_ENVIRONMENT):
			collider.on_unit_hit(owner)
			break
		elif collider.is_in_group(Constants.GROUPNAME_FAMILY):
			collider.on_unit_hit(owner)
			break
		owner.on_unit_hit(collider)
		break;
	# No need to process any further collisionsa
	return
	
	
func create_timer() -> void:
	walk_timer = Timer.new()
	add_child(walk_timer)
	walk_timer.wait_time = randf_range(Constants.HULK_WALK_MIN, Constants.HULK_WALK_MAX)
	walk_timer.one_shot = true
	walk_timer.timeout.connect(on_walk_timer_timeout)
	
	
func on_walk_timer_timeout() -> void:
	get_new_direction()
	
	
func get_new_direction(mustChangeDirection = false) -> void:
	if (mustChangeDirection):
		var current_direction = walk_direction
		while (current_direction == walk_direction):
			current_direction = randi_range(Enums.Direction.NORTH, Enums.Direction.WEST) as Enums.Direction
		walk_direction = current_direction
	else:
		walk_direction = randi_range(Enums.Direction.NORTH, Enums.Direction.WEST) as Enums.Direction
	
	match walk_direction:
		Enums.Direction.EAST:
			animation_player.play("walk_right")
		Enums.Direction.WEST:
			animation_player.play("walk_left")
		Enums.Direction.SOUTH:
			animation_player.play("walk_down")
		Enums.Direction.NORTH:
			animation_player.play("walk_up")
	
	walk_timer.wait_time = randf_range(Constants.HULK_WALK_MIN, Constants.HULK_WALK_MAX)
	walk_timer.start()
	
func notify(notify_data:Dictionary) -> void:
	var data = notify_data.get("unit_hit")
	if (data != null):
		match walk_direction:
			Enums.Direction.EAST:
				owner.position.x -= Constants.HULK_KNOCKBACK
			Enums.Direction.WEST:
				owner.position.x += Constants.HULK_KNOCKBACK
			Enums.Direction.SOUTH:
				owner.position.y -= Constants.HULK_KNOCKBACK
			Enums.Direction.NORTH:
				owner.position.y += Constants.HULK_KNOCKBACK
