# spheroid travelling_to_wall.gd
extends State

var animation_player: AnimationPlayer
var screen_size: Vector2
var target_pos: Vector2
var unit_size: Vector2
var current_wall: Enums.Direction
var boundary_offset: int
var current_direction: Vector2


# Called when entering the Active state
func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	animation_player.play(_msg.animation_name)
	
	unit_size = _msg.unit_size
	screen_size = _msg.screen_size
	boundary_offset = _msg.boundary_offset
	
	get_target_wall()
	
	
func get_target_wall() -> void:
	current_wall = randi_range(Enums.Direction.NORTH, Enums.Direction.WEST) as Enums.Direction
	match current_wall:
		Enums.Direction.NORTH:
			target_pos = Vector2(randf_range(unit_size.x, screen_size.x - unit_size.x), 0)
			#print("spheroid ", owner.name, " target wall is NORTH ", current_wall)
		Enums.Direction.EAST:
			target_pos = Vector2(screen_size.x, randf_range(unit_size.y, screen_size.y - unit_size.y))
			#print("spheroid ", owner.name, " target wall is EAST ", current_wall)
		Enums.Direction.SOUTH:
			target_pos = Vector2(randf_range(unit_size.x, screen_size.x - unit_size.x), screen_size.y)
			#print("spheroid ", owner.name, " target wall is SOUTH ", current_wall)
		Enums.Direction.WEST:
			target_pos = Vector2(0, randf_range(unit_size.y, screen_size.y - unit_size.y))
			#print("spheroid ", owner.name, " target wall is WEST ", current_wall)
	
	
# Main loop
func update(_delta: float) -> void:
	travel_to_wall(_delta)
	
	
func travel_to_wall(_delta: float) -> void:
	current_direction = target_pos - owner.position
	if current_direction.length() > 1.0:
		current_direction = current_direction.normalized()

	owner.velocity = Constants.SPEED_SPHEROID * current_direction
	owner.move_and_slide()
	
	for i in owner.get_slide_collision_count():
		var collider = owner.get_slide_collision(i).get_collider()
		if collider.is_in_group(Constants.GROUPNAME_WALLS):
			state_machine.transition_to(Constants.STATENAME_ACTIVE, {
				"animation_player" : animation_player,
				"screen_size" : screen_size,
				"boundary_offset" : boundary_offset,
				"unit_size" : unit_size,
				"current_wall" : current_wall
			} )
			break
		elif collider.is_in_group(Constants.GROUPNAME_PLAYER):
			#print(owner.name, " (update) hit by ", collider.name)
			owner.on_unit_hit(collider)
			break;

	# No need to process any further collisionsa
	return
