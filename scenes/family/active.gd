# family active.gd
extends State

var animation_player : AnimationPlayer
var player_node : Node2D
var walk_direction : Enums.Direction
var walk_timer : Timer
var animation_prefix : int


# Called when entering the state
func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	player_node = _msg.player_node
	animation_prefix = _msg.animation_prefix
	
	walk_timer = owner.get_node("Timer")
	get_new_direction(false)


# Called when leaving the state
func exit() -> void:
	walk_timer.stop()


# Main loop
func update(_delta: float) -> void:
	var direction = Constants.WALK_DIRECTIONS[walk_direction]
	owner.velocity = Constants.SPEED_FAMILY * direction
	owner.move_and_slide()
	
	for i in owner.get_slide_collision_count():
		var collider = owner.get_slide_collision(i).get_collider()
		#print(owner.name, " hit by ", collider.name)
		if collider.is_in_group(Constants.GROUPNAME_WALLS):
			# If the family member has hit a wall, they must change direction
			get_new_direction(true)
			break
		# Electrodes are static objects and can't detect collisions themselves,
		# so we need to tell them they've been hit
		elif collider.is_in_group(Constants.GROUPNAME_ENVIRONMENT):
			owner.on_unit_hit(collider)
			break
		# Family members can only be destroyed by Hulks
		elif collider.is_in_group(Constants.GROUPNAME_ENEMIES) && collider.unitType == Enums.UnitType.HULK:
			owner.on_unit_hit(collider)
		elif collider.is_in_group(Constants.GROUPNAME_PLAYER):
			owner.on_player_hit(collider)
			break
		break;
	# No need to process any further collisionsa
	return


func on_walk_timer_timeout() -> void:
	get_new_direction(false)

	
func get_new_direction(mustChangeDirection : bool) -> void:
	walk_timer.wait_time = randf_range(Constants.FAMILY_WALK_MIN, Constants.FAMILY_WALK_MAX)
	
	if (mustChangeDirection):
		var current_direction = walk_direction
		while (current_direction == walk_direction):
			current_direction = randi_range(Enums.Direction.NORTH, Enums.Direction.WEST) as Enums.Direction
		walk_direction = current_direction
	else:
		walk_direction = randi_range(Enums.Direction.NORTH, Enums.Direction.WEST) as Enums.Direction
	
	match walk_direction:
		Enums.Direction.EAST:
			animation_player.play("%d_walk_right" % animation_prefix)
		Enums.Direction.WEST:
			animation_player.play("%d_walk_left" % animation_prefix)
		Enums.Direction.SOUTH:
			animation_player.play("%d_walk_down" % animation_prefix)
		Enums.Direction.NORTH:
			animation_player.play("%d_walk_up" % animation_prefix)
		
	walk_timer.start()
	
