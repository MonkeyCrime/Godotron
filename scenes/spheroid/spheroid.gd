# spheroid
class_name Spheroid
extends EnemyBase

var animation_player: AnimationPlayer
var state_machine: StateMachine
var animation_name: String
var screen_size: Vector2
var unit_size: Vector2
var boundary_offset: int
var spawn_timer: Timer

# Called from the Level Manager when first added to the scene
func initialise(init_data:Dictionary) -> void:
	unitType = Enums.UnitType.SPHEROID
	
	animation_player = get_node("AnimationPlayer")
	state_machine = get_node("StateMachine")
	spawn_timer = get_node("Timer")
	
	position = init_data["pos"]
	animation_name = Constants.ANIM_SPHEROID_NAME
	
	var sprite = get_node("Sprite2D")
	unit_size = sprite.texture.get_size()
	unit_size.x = unit_size.x / sprite.hframes
	unit_size.y = unit_size.y / sprite.vframes
	
	disable_player_collisions(false)
	
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
		"animation_name" : animation_name
	})
	
	
func _ready() -> void:
		screen_size = get_parent().get_viewport_rect().size
		boundary_offset = get_parent().get_node("WorldBoundary/Top").position.y
	
	
func _on_tree_entered():
	Events.safe_connect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_connect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_connect(Constants.EVENT_PLAYER_INVULNERABLE, on_disable_player_collisions)
	
func _on_tree_exiting():
	Events.safe_disconnect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_disconnect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_disconnect(Constants.EVENT_PLAYER_INVULNERABLE, on_disable_player_collisions)
	
	
# Emitted by the level when it's gameplay-ready
func on_units_activated() -> void:
	disable_player_collisions(false)
	
	state_machine.transition_to(Constants.STATENAME_TRAVELLING_WALL, {
		"animation_player" : animation_player,
		"animation_name" : animation_name,
		"screen_size" : screen_size,
		"boundary_offset" : boundary_offset,
		"unit_size" : unit_size
	} )
	
	
func on_unit_hit(_collider:Node2D) -> void:
	if processing_collisions:
		return

	disable_player_collisions(true)
	spawn_timer.stop()
	
	Events.emit_signal(Constants.EVENT_ENEMY_HIT, self)
	Events.emit_signal(Constants.EVENT_UI_UPDATE_POINTS, { "points" : Constants.POINTS_SPHEROID } )

	state_machine.transition_to(Constants.STATENAME_EXITLEVEL, {
		"animation_player" : animation_player,
	} )
	
	
func on_units_idle() -> void:
	if state_machine.state.name == Constants.STATENAME_EXITLEVEL:
		return;
		
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
		"animation_name" : animation_name
	} )
	
	
func disable_player_collisions(state: bool) -> void:
	processing_collisions = state
	on_disable_player_collisions(state)
	
	
func on_disable_player_collisions(state: bool) -> void:
	set_collision_mask_value(Constants.COLLISION_MASK_PLAYER, not state)
	
	
