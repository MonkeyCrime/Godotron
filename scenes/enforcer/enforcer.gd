# enforcer
class_name Enforcer
extends EnemyBase

var animation_player: AnimationPlayer
var state_machine: StateMachine
var player_node: Node2D
var enforcer_speed: int

# Called from the Level Manager when first added to the scene
func initialise(init_data: Dictionary) -> void:
	unitType = Enums.UnitType.ENFORCER
	
	animation_player = get_node("AnimationPlayer")
	state_machine = get_node("StateMachine")

	position = init_data["pos"]
	player_node = init_data["player_node"]
	enforcer_speed = init_data["level_data"].enforcer_speed
	
	disable_player_collisions(false)
	
	state_machine.transition_to(Constants.STATENAME_ENTERLEVEL, {
		"animation_player" : animation_player,
		"animation_name" : "enter_level",
		"player_node" : player_node
	})
	
	
func _ready() -> void:
	pass
	
	
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
	
	state_machine.transition_to(Constants.STATENAME_ACTIVE, {
		"player_node" : player_node
	} )
	
	
func on_unit_hit(_collider: Node2D) -> void:
	if processing_collisions:
		return

	disable_player_collisions(true)
	
	Events.emit_signal(Constants.EVENT_ENEMY_HIT, self)
	Events.emit_signal(Constants.EVENT_UI_UPDATE_POINTS, { "points" : Constants.POINTS_ENFORCER } )

	state_machine.transition_to(Constants.STATENAME_EXITLEVEL, {
		"animation_player" : animation_player,
		"animation_name" : "exit_level"
	} )
	
	
func on_units_idle() -> void:
	if state_machine.state.name == Constants.STATENAME_EXITLEVEL:
		return;
		
	state_machine.transition_to(Constants.STATENAME_IDLE, { } )
	
	
# Relay any animation-complete events to the active state
func _on_animation_finished(anim_name) -> void:
	state_machine.notify( {
		"animation_name" : anim_name
	} )
	
func disable_player_collisions(state: bool) -> void:
	processing_collisions = state
	on_disable_player_collisions(state)
	
	
func on_disable_player_collisions(state : bool) -> void:
	set_collision_mask_value(Constants.COLLISION_MASK_PLAYER, not state)
	
	
