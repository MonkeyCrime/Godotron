# spheroid active.gd
extends State

var animation_player: AnimationPlayer
var screen_size: Vector2
var target_pos: Vector2
var unit_size: Vector2
var current_wall: Enums.Direction
var boundary_offset: int
var current_direction: Vector2
var spawn_timer: Timer

# Called when entering the Active state
func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	#animation_player.play(_msg.anim_name)
	
	unit_size = _msg.unit_size
	screen_size = _msg.screen_size
	current_wall = _msg.current_wall
	boundary_offset = _msg.boundary_offset
	
	spawn_timer = owner.get_node("Timer")
	spawn_timer.wait_time = randf_range(Constants.SPHEROID_SPAWNTIME_MIN, Constants.SPHEROID_SPAWNTIME_MAX)
	spawn_timer.one_shot = true
	if not spawn_timer.is_connected("timeout", _on_spawn_timer_timeout):
		spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.start()
	
	#print("spheroid ", owner.name, " enter Active, current_wall is ", current_wall)
	
	get_random_direction()
	
	
# Main loop
func update(_delta: float) -> void:
	move_along_wall(_delta)
	
	
func move_along_wall(_delta: float) -> void:
	var position = ceil(owner.position)
	
	match current_direction:
		Vector2.RIGHT:
			if position.x >= screen_size.x - unit_size.x / 2:
				if position.y <= unit_size.y / 2 + boundary_offset:
					current_direction = Vector2.LEFT if randi_range(0, 10) >= 5 else Vector2.DOWN
				elif position.y >= screen_size.y - unit_size.y / 2:
					current_direction = Vector2.LEFT if randi_range(0, 10) >= 5 else Vector2.UP
		Vector2.LEFT:
			if position.x <= unit_size.x / 2:
				if position.y <= unit_size.y / 2 + boundary_offset:
					current_direction = Vector2.RIGHT if randi_range(0, 10) >= 5 else Vector2.DOWN
				elif position.y >= screen_size.y - unit_size.y / 2:
					current_direction = Vector2.RIGHT if randi_range(0, 10) >= 5 else Vector2.UP
		Vector2.UP:
			if position.y <= unit_size.y / 2 + boundary_offset:
				if position.x <= unit_size.x / 2:
					current_direction = Vector2.RIGHT if randi_range(0, 10) >= 5 else Vector2.DOWN
				elif position.x >= screen_size.x - unit_size.x / 2:
					current_direction = Vector2.LEFT if randi_range(0, 10) >= 5 else Vector2.DOWN
		Vector2.DOWN:
			if position.y >= screen_size.y - unit_size.y / 2:
				if position.x <= unit_size.x / 2:
					current_direction = Vector2.RIGHT if randi_range(0, 10) >= 5 else Vector2.UP
				elif position.x >= screen_size.x - unit_size.x / 2:
					current_direction = Vector2.LEFT if randi_range(0, 10) >= 5 else Vector2.UP

	owner.velocity = Constants.SPEED_SPHEROID * current_direction
	owner.move_and_slide()
	
	for i in owner.get_slide_collision_count():
		var collider = owner.get_slide_collision(i).get_collider()
		if collider.is_in_group("Player"):
			print(owner.name, " (update) hit by ", collider.name)
			owner.on_unit_hit(collider)
			break;

	
func get_random_direction() -> void:
	match current_wall:
		Enums.Direction.NORTH:
			current_direction = Vector2.LEFT if randi_range(0, 10) >= 5 else Vector2.RIGHT
		Enums.Direction.SOUTH:
			current_direction = Vector2.LEFT if randi_range(0, 10) >= 5 else Vector2.RIGHT
		Enums.Direction.EAST:
			current_direction = Vector2.UP if randi_range(0, 10) >= 5 else Vector2.DOWN
		Enums.Direction.WEST:
			current_direction = Vector2.UP if randi_range(0, 10) >= 5 else Vector2.DOWN
	
	#print("spheroid ", owner.name, " random direction is ", current_direction, " current_wall was ", current_wall)
	
	
func _on_spawn_timer_timeout() -> void:
	Events.emit_signal(Constants.EVENT_SPAWN_ENEMY, {
		"pos" : owner.position,
		"unit_type" : Enums.UnitType.ENFORCER
	} )
	
	spawn_timer.wait_time = randf_range(Constants.SPHEROID_SPAWNTIME_MIN, Constants.SPHEROID_SPAWNTIME_MAX)
	spawn_timer.start()
