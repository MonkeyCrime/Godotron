# player.gd

extends CharacterBody2D
class_name Player

var num_lives = Config.PLAYER_LIVES
var unitType = Enums.UnitType.PLAYER
var bullet

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var invulnerableAnimationPlayer: AnimationPlayer = $InvulnerabilityAnimationPlayer
@onready var state_machine : StateMachine = $StateMachine
@onready var invulnerability_timer = $InvulnerabiltyTimer
@onready var player_collider = $CollisionShape2D

func _ready():
	bullet = preload(Constants.SCENE_BULLET)
	# TODO: Replace this magic number
	#$Sprite2D.frame = 24
		
	Events.safe_connect(Constants.EVENT_UNITS_SPAWNED, on_units_spawned)
	Events.safe_connect(Constants.EVENT_UNITS_ACTIVATED, on_units_activated)
	Events.safe_connect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	Events.safe_connect(Constants.EVENT_PLAYER_ENTRY_COMPLETE, on_player_enter_level_complete)
	Events.safe_connect(Constants.EVENT_PLAYER_ADD_LIVES, on_player_add_lives)

# Emitted by the level when all units have been spawned for the level
func on_units_spawned():
	state_machine.transition_to("EnterLevel", {
		"animation_player" : animation_player
	} )

# Emitted by the level when ready to start game play. Fired after the player intro
# animation has completed
func on_units_activated():
	state_machine.transition_to("Active", {
		"animation_player" : animation_player,
		"bullet" : bullet,
	} )

# Emitted by the level when all enemies have been destroyed.
func on_level_complete() -> void:
	state_machine.transition_to("ExitLevel", {
		"animation_player" : animation_player
	} )

func on_player_enter_level_complete():
	enable_invulnerability()


func enable_invulnerability():
	Events.emit_signal(Constants.EVENT_PLAYER_INVULNERABLE, true)

	invulnerableAnimationPlayer.play("invulnerable")
	set_collision_mask_value(1, false)
	set_collision_mask_value(5, false)
	
	invulnerability_timer.wait_time = Config.PLAYER_INVULNERABLE_TIME
	invulnerability_timer.one_shot = true
	if not invulnerability_timer.is_connected("timeout", on_invulnerability_timer_timeout):
		invulnerability_timer.connect("timeout", on_invulnerability_timer_timeout)
	invulnerability_timer.start()
	
func on_invulnerability_timer_timeout():
	Events.emit_signal(Constants.EVENT_PLAYER_INVULNERABLE, false)

	invulnerableAnimationPlayer.stop()
	set_collision_mask_value(1, true)
	set_collision_mask_value(5, true)

	
func on_unit_hit(_collider:Node2D):
	#print(name, " (on_unit_hit) ", _collider.name)

	if invulnerableAnimationPlayer.is_playing():
		return
	
	# Pause all enemies while we respawn the player
	Events.emit_signal(Constants.EVENT_UNITS_IDLE)
	
	num_lives -= 1
	if num_lives == 0:
		Events.emit_signal(Constants.EVENT_LEVEL_COMPLETE)
		Events.emit_signal(Constants.EVENT_GAME_OVER)
		return

	# Only transition to the Died state if we're active. This can be called in
	# the ExitLevel state too, if the player walks into the last enemy in the level
	if (state_machine.state.name == "Active"):
		state_machine.transition_to("Died", {
		"animation_player" : animation_player
		} )

# Notify the current state of any top-level events in the node
func on_animation_finished(anim_name):
	state_machine.notify( {
		"event_name" : "on_animation_finished",
		"anim_name" : anim_name
	} )

func on_player_add_lives(lives:int):
	num_lives += lives
	Events.emit_signal(Constants.EVENT_UI_UPDATE_LIVES, {
		"lives" : num_lives
	})
