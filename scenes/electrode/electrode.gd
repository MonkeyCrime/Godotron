# electrode
class_name Electrode
extends EnemyBase

var animationPlayer: AnimationPlayer
var state_machine: StateMachine
var collision_shape: Node2D
var animation_name: String
var sprite: Sprite2D


# Called from the Level Manager when first added to the scene
func initialise(init_data: Dictionary) -> void:
	unitType = Enums.UnitType.ELECTRODE
	
	animationPlayer = get_node("AnimationPlayer")
	state_machine = get_node("StateMachine")
	collision_shape = get_node("CollisionShape2D")
	sprite = get_node("Sprite2D")
	
	position = init_data["pos"]
	sprite.rotation_degrees = 0
	sprite.scale = Vector2.ONE
	animation_name = Constants.ANIM_ELECTRODE_NAME % randi_range(
		Constants.ANIM_ELECTRODE_MIN, 
		Constants.ANIM_ELECTRODE_MAX)

	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animationPlayer,
		"animation_name" : animation_name
	})
	
	
func _ready() -> void:
	pass
	
func _on_tree_entered():
	Events.safe_connect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_connect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_connect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	
func _on_tree_exiting():
	Events.safe_disconnect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_disconnect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_disconnect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	
	
# Emitted by the level when it's gameplay-ready
func on_units_activated() -> void:
	collision_shape.disabled = false
	state_machine.transition_to(Constants.STATENAME_ACTIVE, {
		"animation_player" : animationPlayer,
		"animation_name" : animation_name
	} )
	
	
func on_unit_hit(_collider:Node2D) -> void:
	collision_shape.disabled = true
	
	Events.emit_signal(Constants.EVENT_UI_UPDATE_POINTS, { "points" : Constants.POINTS_ELECTRODE } )

	state_machine.transition_to(Constants.STATENAME_EXITLEVEL, {
		"animation_player" : animationPlayer,
	} )
	
	
func on_units_idle() -> void:
	if state_machine.state.name == Constants.STATENAME_EXITLEVEL:
		return
		
	state_machine.transition_to(Constants.STATENAME_IDLE, {
		"animation_player" : animationPlayer,
		"animation_name" : animation_name
	} )
	
	
func on_level_complete() -> void:
	Events.emit_signal(Constants.EVENT_ENEMY_DEAD, self)
	
	
