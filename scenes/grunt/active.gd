# grunt active.gd
extends State

var idle_time: float = 0.25
var move_time: float = 0.5

var animation_player: AnimationPlayer
var move_timer: Timer
var player_node: Node2D
var grunt_move_mode: Enums.GruntMoveMode


# Called when entering the Active state
func enter(_msg:= {}) -> void:
	animation_player = _msg.animation_player
	player_node = _msg.player_node
	idle_time = _msg.idle_time
	move_time = _msg.move_time
	grunt_move_mode = Enums.GruntMoveMode.DELAY_START
	
	create_timer()
	
	
# Called when leaving the Active state
func exit() -> void:
	move_timer.stop()
	
	
# Main loop
func update(_delta: float) -> void:
	var direction = Vector2.ZERO
	
	if grunt_move_mode == Enums.GruntMoveMode.MOVING:
		direction = player_node.global_position - owner.global_position

	if direction.length() > 1.0:
		direction = direction.normalized()

	owner.velocity = Constants.SPEED_GRUNT * direction
	owner.move_and_slide()
	
	for i in owner.get_slide_collision_count():
		var collider = owner.get_slide_collision(i).get_collider()
		#print(owner.name, " (update) hit by ", collider.name)
		if collider.is_in_group(Constants.GROUPNAME_PLAYER):
			collider.on_unit_hit(owner)
		owner.on_unit_hit(collider)
		break;
	# No need to process any further collisionsa
	return
	
	
func create_timer() -> void:
	move_timer = Timer.new()
	add_child(move_timer)
	move_timer.wait_time = randf() * Constants.GRUNT_RANDOM_WAITTIME
	move_timer.one_shot = true
	move_timer.timeout.connect(_moveTimerTimeout)
	move_timer.start()
	
	
func _moveTimerTimeout() -> void:
	match grunt_move_mode:
		Enums.GruntMoveMode.DELAY_START:
			move_timer.wait_time = move_time
			grunt_move_mode = Enums.GruntMoveMode.MOVING
		Enums.GruntMoveMode.STANDING:
			move_timer.wait_time = move_time
			grunt_move_mode = Enums.GruntMoveMode.MOVING
			animation_player.play("walk")
		Enums.GruntMoveMode.MOVING:
			move_timer.wait_time = idle_time
			grunt_move_mode = Enums.GruntMoveMode.STANDING
			animation_player.play("idle")
	
	move_timer.start()
