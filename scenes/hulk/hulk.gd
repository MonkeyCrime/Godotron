# hulk
class_name Hulk
extends EnemyBase

var player_node: Node2D
var animation_player: AnimationPlayer
var state_machine: StateMachine

# Called from the Level Manager when first added to the scene
func initialise(init_data: Dictionary) -> void:
	unitType = Enums.UnitType.HULK
	
	animation_player = get_node("AnimationPlayer")
	state_machine = get_node("StateMachine")
	
	position = init_data["pos"]
	player_node = init_data["player_node"]
	
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
		"animation_name" : "idle"
	} )
	
	
func _ready() -> void:
	pass
	
	
func _on_tree_entered():
	Events.safe_connect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_connect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_connect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	Events.safe_connect(Constants.EVENT_PLAYER_INVULNERABLE, on_disable_player_collisions)
	
	
func _on_tree_exiting():
	Events.safe_disconnect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_disconnect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_disconnect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	Events.safe_disconnect(Constants.EVENT_PLAYER_INVULNERABLE, on_disable_player_collisions)
	
	
# Emitted by the level when it's gameplay-ready
func on_units_activated() -> void:
	disable_player_collisions(false)
	
	state_machine.transition_to(Constants.STATENAME_ACTIVE, {
		"animation_player" : animation_player,
		"player_node" : player_node,
	} )
	
	
# Relay any animation-complete events to the active state
func on_animation_finished(anim_name) -> void:
	state_machine.notify( {
		"animation_name" : anim_name
	} )
	
	
func on_unit_hit(_collider: Node2D) -> void:
	state_machine.notify( {
		"unit_hit" : "null"
	} )


func on_units_idle() -> void:
	if state_machine.state.name == Constants.STATENAME_EXITLEVEL:
		return;
		
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
	} )
	
	
func on_level_complete() -> void:
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
	} )

	Events.emit_signal(Constants.EVENT_ENEMY_DEAD, self)
	
	
func disable_player_collisions(state: bool) -> void:
	processing_collisions = state
	on_disable_player_collisions(state)
	
	
func on_disable_player_collisions(state : bool) -> void:
	set_collision_mask_value(Constants.COLLISION_MASK_PLAYER, not state)
	set_collision_mask_value(Constants.COLLISION_MASK_PLAYER_SHOTS, not state)
	
	
