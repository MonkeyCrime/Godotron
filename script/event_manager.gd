extends Node

var listeners = {}

signal enemy_hit(node:Node2D)
signal enemy_dead(node:EnemyBase)

signal game_over()

signal player_enter_level_complete()
signal player_exit_level_complete()
signal player_invulnerable(active:bool)
signal player_rescue_family(_node:Node2D)
signal player_add_lives(num_lives:int)
signal player_play_bonus(data:Dictionary)

signal units_spawned()
signal units_idle()
signal units_activated()

signal level_complete()

signal transition_intro_complete()
signal transition_outro_complete()

signal ui_initialise(ui_data:Dictionary)
signal ui_update_lives(ui_data:Dictionary)
signal ui_update_wave(ui_data:Dictionary)
signal ui_update_points(ui_data:Dictionary)

signal spawn_enemy(spawn_data:Dictionary)

func safe_connect(signal_name:StringName, callback:Callable):
	if not is_connected(signal_name, callback):
		connect(signal_name, callback)
	
	
func safe_disconnect(signal_name:StringName, callback:Callable):
	if is_connected(signal_name, callback):
		disconnect(signal_name, callback)
	
	
func _ready():
	randomize()
