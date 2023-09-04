# player active.gd
extends State

var animation_player: AnimationPlayer
var bullet
var bullet_timer = 0
var root : Node2D

# Map shot directions to launch points around the player
var bullet_dictionary = {}

func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	bullet = _msg.bullet
	root = owner.get_parent()
	
	# Map shot directions to launch points around the player
	bullet_dictionary = {
		Vector2(0,  -1): owner.get_node("Fire_North"),
		Vector2(1,  -1): owner.get_node("Fire_NorthEast"),
		Vector2(1,   0): owner.get_node("Fire_East"),
		Vector2(1,   1): owner.get_node("Fire_SouthEast"),
		Vector2(0,   1): owner.get_node("Fire_South"),
		Vector2(-1,  1): owner.get_node("Fire_SouthWest"),
		Vector2(-1,  0): owner.get_node("Fire_West"),
		Vector2(-1, -1): owner.get_node("Fire_NorthWest"),
}

func physics_update(delta: float) -> void:
	handle_shooting(delta)
	handle_movement(delta)
	handle_collisions()

func handle_movement(_delta:float):
	# Once again, we call 'Input.get_action_strength()' to support analog movement
	var direction := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)

	# Normalise travel when walking diagonally
	if direction.length() > 1.0:
		direction = direction.normalized()

	# If the player is not moving, eyes straight ahead
	if direction == Vector2.ZERO:
		animation_player.play("idle")

	if Input.is_action_pressed("move_right"):
		animation_player.play("walk_right")
	elif Input.is_action_pressed("move_left"):
		animation_player.play("walk_left")
	elif Input.is_action_pressed("move_down"):
		animation_player.play("walk_down")
	elif Input.is_action_pressed("move_up"):
		animation_player.play("walk_up")

	owner.velocity = Config.PLAYER_SPEED * direction
	owner.move_and_slide()
	
func handle_collisions():
	# This flag distinguishes between enemy hits and wall hits
	var enemy_collider:Node2D = null
	var count = owner.get_slide_collision_count()
	for i in count:
		# It's possible we could be hit by multiple enemies at the same time,
		# so we'll loop through all colliders and tell them about the collision
		var collider = owner.get_slide_collision(i).get_collider()
		#print(owner.name, " (update) ", collider.name)
		if collider.is_in_group("Enemies") && not collider.processing_collisions:
			enemy_collider = collider
			collider.on_unit_hit(owner)
			break
		elif collider.is_in_group("Environment"):
			enemy_collider = collider
			collider.on_unit_hit(owner)
			break
		elif collider.is_in_group("Family"):
			collider.on_player_hit(owner)
			break
	# Call our own unit hit method to pause enemies, die, and transition the state
	if enemy_collider != null:
		owner.on_unit_hit(enemy_collider)

func handle_shooting(delta:float):
	bullet_timer -= delta
	if bullet_timer > 0:
		return
		
	var shot_direction = Vector2.ZERO

	if Input.is_action_pressed("fire_up"):
		shot_direction.y = -1
	if Input.is_action_pressed("fire_down"):
		shot_direction.y = 1
	if Input.is_action_pressed("fire_left"):
		shot_direction.x = -1
	if Input.is_action_pressed("fire_right"):
		shot_direction.x = 1

	if shot_direction == Vector2.ZERO:
		return

	shootProjectile(shot_direction)
	bullet_timer = Config.PLAYER_SHOT_DELAY

func shootProjectile(shot_direction:Vector2):
	var newBullet = bullet.instantiate()
	assert(newBullet)

	root.add_child(newBullet)

	var bullet_launch = bullet_dictionary[shot_direction]
	newBullet.position = bullet_launch.global_position
	newBullet.rotation = bullet_launch.global_rotation
	newBullet.velocity = shot_direction * Config.PLAYER_SHOT_SPEED
