# grunt
class_name Grunt
extends EnemyBase

var idle_time: float = 1.0
var move_time: float = 1.0
var player_node: Node2D
var animation_player: AnimationPlayer
var state_machine: StateMachine
var move_timer: Timer


# Called from the Level Manager when first added to the scene
func initialise(init_data: Dictionary) -> void:
	unitType = Enums.UnitType.GRUNT
	
	animation_player = get_node("AnimationPlayer")
	state_machine = get_node("StateMachine")
	
	position = init_data["pos"]
	player_node = init_data["player_node"]
	idle_time = init_data["level_data"].idle_time
	move_time = init_data["level_data"].move_time

	disable_player_collisions(false)
	
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
		"animation_name" : "idle"
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
		"animation_player" : animation_player,
		"player_node" : player_node,
		"idle_time" : idle_time,
		"move_time" : move_time,
	} )
	
	
# Relay any animation-complete events to the active state
func on_animation_finished(anim_name: StringName) -> void:
	state_machine.notify( {
		"animation_name" : anim_name
	} )
	
	
func on_unit_hit(_collider: Node2D) -> void:
	if processing_collisions:
		return
	
	disable_player_collisions(true)
	
	Events.emit_signal(Constants.EVENT_ENEMY_HIT, self)
	Events.emit_signal(Constants.EVENT_UI_UPDATE_POINTS, { "points" : Constants.POINTS_GRUNT } )

	state_machine.transition_to(Constants.STATENAME_EXITLEVEL, {
		"animation_player" : animation_player,
		"animation_name" : "exit_level"
	} )
	
	
func on_units_idle() -> void:
	if state_machine.state.name == Constants.STATENAME_EXITLEVEL:
		return;
		
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animation_player,
		"animation_name" : "idle"
	} )
	
	
func disable_player_collisions(state: bool) -> void:
	processing_collisions = state
	on_disable_player_collisions(state)
	
	
func on_disable_player_collisions(state : bool) -> void:
	set_collision_mask_value(Constants.COLLISION_MASK_PLAYER, not state)
	
	
