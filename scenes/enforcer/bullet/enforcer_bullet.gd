# enforcer_bullet.gd
class_name EnforcerBullet
extends EnemyBase

var bullet_format_string = "%s"
var player_node : Node2D
var direction : Vector2
var animationPlayer: AnimationPlayer


# Called from the Level Manager when first added to the scene
func initialise(init_data: Dictionary) -> void:
	unitType = Enums.UnitType.ENFORCER_BULLET
	
	animationPlayer = get_node("AnimationPlayer")
	
	position = init_data["pos"]
	player_node = init_data["player_node"]
	direction = player_node.global_position - position
	if direction.length() > 1.0:
		direction = direction.normalized()
	
	disable_player_collisions(false)
	animationPlayer.play("active")
	
	
func _ready() -> void:
	var bulletName = name.replace("@CharacterBody2D@", "EnforcerBullet_")
	set_name(bulletName)
	
	
func _on_tree_entered():
	Events.safe_connect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_connect(Constants.EVENT_PLAYER_INVULNERABLE, on_disable_player_collisions)
	
	
func _on_tree_exiting():
	Events.safe_disconnect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_disconnect(Constants.EVENT_PLAYER_INVULNERABLE, on_disable_player_collisions)
	
	
func _physics_process(_delta: float) -> void:
	velocity = Constants.SPEED_ENFORCER_BULLET * direction
	
	move_and_slide()
	var count = get_slide_collision_count()
	if count > 0:
		# Get rid of the bullet as it's hit something
		Events.emit_signal(Constants.EVENT_ENEMY_DEAD, self)

		# Let whatever the bullet has hit know its been hit
		for i in count:
			var collider = get_slide_collision(i).get_collider()
			#print(name, " (update) ", collider.name)
			if collider.is_in_group(Constants.GROUPNAME_PLAYER):
				collider.on_unit_hit(self)
				break
	
	
func on_unit_hit(_collider: Node2D) -> void:
	Events.emit_signal(Constants.EVENT_ENEMY_DEAD, self)
	
	
# Emitted by the level when it's gameplay-ready
func on_units_activated() -> void:
	disable_player_collisions(false)
	
	
func disable_player_collisions(state: bool) -> void:
	processing_collisions = state
	on_disable_player_collisions(state)
	
	
func on_disable_player_collisions(state: bool) -> void:
	set_collision_mask_value(Constants.COLLISION_MASK_PLAYER, not state)
	
	
