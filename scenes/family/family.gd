# family
class_name Family
extends EnemyBase

var player_node : Node2D
var player_sprite : Node2D
var bonus_sprite : Node2D
var animationPlayer : AnimationPlayer
var state_machine : StateMachine
var collision_shape : Node2D
var animation_prefix : int

# Called from the Level Manager when first added to the scene
func initialise(init_data:Dictionary):
	unitType = Enums.UnitType.FAMILY
	
	animationPlayer = get_node("AnimationPlayer")
	state_machine = get_node("StateMachine")
	collision_shape = get_node("CollisionShape2D")
	player_sprite = get_node("Sprite2D")
	bonus_sprite = get_node("BonusSprite")

	position = init_data["pos"]
	player_node = init_data["player_node"]
	collision_shape.disabled = false
	animation_prefix = randi_range(Enums.FamilyMember.DADDY, Enums.FamilyMember.MIKEY)
	player_sprite.modulate.a = 1.0
	bonus_sprite.modulate.a = 0.0
	
	state_machine.transition_to("Idle", {
		"animation_player" : animationPlayer,
		"animation_prefix" : animation_prefix
	} )
	

func _ready():
	pass
	
	
func _on_tree_entered():
	Events.safe_connect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_connect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_connect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	Events.safe_connect(Constants.EVENT_PLAYER_PLAY_BONUS, on_player_play_bonus)
	
func _on_tree_exiting():
	Events.safe_disconnect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_disconnect(Constants.EVENT_UNITS_IDLE, on_units_idle)
	Events.safe_disconnect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	Events.safe_disconnect(Constants.EVENT_PLAYER_PLAY_BONUS, on_player_play_bonus)
	
	
# Emitted by the level when it's gameplay-ready
func on_units_activated():
	collision_shape.disabled = false
	state_machine.transition_to("Active", {
		"animation_player" : animationPlayer,
		"player_node" : player_node,
		"animation_prefix" : animation_prefix
	} )


# Relay any animation-complete events to the active state
func on_animation_finished(anim_name):
	state_machine.notify( {
		"animation_player" : animationPlayer,
		"animation_name" : anim_name
	} )

func on_player_hit(_collider:Node2D):
	collision_shape.disabled = true
	Events.emit_signal(Constants.EVENT_PLAYER_RESCUE_FAMILY, self)
	#Events.emit_signal(Constants.EVENT_ENEMY_DEAD, self)

func on_unit_hit(_collider:Node2D):
	collision_shape.disabled = true
	#print(name, " hit by ", _collider.name)
	state_machine.transition_to("ExitLevel", {
		"animation_player" : animationPlayer,
		"animation_name" : "exit_level"
	} )


func on_units_idle():
	collision_shape.disabled = true
	state_machine.transition_to("Idle", {
		"animation_player" : animationPlayer,
		"animation_prefix" : animation_prefix
	} )
	
	
func on_level_complete() -> void:
	state_machine.transition_to("ExitLevel", {
		"animation_player" : animationPlayer,
		"animation_name" : "hidden"
	} )

	Events.emit_signal(Constants.EVENT_ENEMY_DEAD, self)

func on_player_play_bonus(data:Dictionary):
	if data.node != self:
		return
	
	player_sprite.modulate.a = 0.0
	bonus_sprite.modulate.a = 1.0
	collision_shape.disabled = true
	state_machine.transition_to("PlayBonus", {
		"animation_player" : animationPlayer,
		"animation_name" : "bonus_%d" % data.points
	} )
	
	
