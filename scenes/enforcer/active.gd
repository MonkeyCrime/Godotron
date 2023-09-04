# enforcer active.gd
extends State

var player_node:Node2D
var shot_timer : Timer


# Called when entering the Active state
func enter(_msg:= {}) -> void:
	player_node = _msg.player_node
	
	shot_timer = owner.get_node("Timer")
	shot_timer.wait_time = randf_range(Constants.ENFORCER_MIN_FIRETIME, Constants.ENFORCER_MAX_FIRETIME)
	shot_timer.one_shot = true
	if not shot_timer.is_connected("timeout", _shotTimerTimeout):
		shot_timer.timeout.connect(_shotTimerTimeout)
	shot_timer.start()
	
	
# Called when leaving the Active state
func exit() -> void:
	shot_timer.stop()
	
	
# Main loop
func update(_delta: float) -> void:
	var direction = player_node.global_position - owner.global_position
	if direction.length() > 1.0:
		direction = direction.normalized()

	owner.velocity = owner.enforcer_speed * direction
	owner.move_and_slide()

	for i in owner.get_slide_collision_count():
		var collider = owner.get_slide_collision(i).get_collider()
		#print(owner.name, " (update) hit by ", collider.name)
		owner.on_unit_hit(collider)
		break;

	# No need to process any further collisionsa
	return
	
	
func _shotTimerTimeout() -> void:
	Events.emit_signal(Constants.EVENT_SPAWN_ENEMY, {
		"pos" : owner.position,
		"unit_type" : Enums.UnitType.ENFORCER_BULLET
	} )
		
	shot_timer.wait_time = randf_range(Constants.ENFORCER_MIN_FIRETIME, Constants.ENFORCER_MAX_FIRETIME)
	shot_timer.start()
	
