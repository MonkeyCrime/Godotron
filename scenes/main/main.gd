# main.gd

extends Node2D

var spawnManager: SpawnManager
var levelManager: LevelManager

func _ready() -> void:
	Events.safe_connect(Constants.EVENT_PLAYER_ENTRY_COMPLETE, on_player_enter_level_complete)
	Events.safe_connect(Constants.EVENT_PLAYER_EXIT_COMPLETE, on_player_exit_level_complete)
	Events.safe_connect(Constants.EVENT_LEVEL_COMPLETE, on_level_complete)
	Events.safe_connect(Constants.EVENT_GAME_OVER, on_game_over)

	spawnManager = SpawnManager.new()
	spawnManager.initialise(self)
	
	levelManager = LevelManager.new()
	levelManager.initialise(self, spawnManager, get_viewport_rect().size, get_node("CentreRaycast"))
	
	Events.emit_signal(Constants.EVENT_UI_INITIALISE, {
		"lives" : Config.PLAYER_LIVES,
		"points" : 0,
		"wave" : levelManager.level_display + 1
	})
	
	next_level()
	
	
func next_level() -> void:
	levelManager.initialiseNextLevel(self)
	
	var player = spawnManager.getNodeByIndex(Enums.UnitType.PLAYER, 0)
	spawnManager.enableAndShowNode(player)
	
	Events.emit_signal(Constants.EVENT_UNITS_SPAWNED)
	Events.emit_signal(Constants.EVENT_UI_UPDATE_WAVE, {
		"wave" : levelManager.level_display
	})
	
	
func on_game_over() -> void:
	await SceneTransition.fade_out()
	await SceneTransition.fade_in()
	get_tree().change_scene_to_file(Constants.SCENE_MAIN_MENU)
	
	
func on_level_complete() -> void:
	# Clean up
	levelManager.removeAllProjectiles(self)
	
	
# Emitted by the Player instance when the "enter level" animation has completed
func on_player_enter_level_complete() -> void:
	# Let everything know it's time to party
	Events.emit_signal(Constants.EVENT_UNITS_ACTIVATED)
	
	
# Emitted by the Player instance when the "exit level" animation has completed
func on_player_exit_level_complete():
	await SceneTransition.fade_out()
	
	levelManager.hide_player()
	next_level()

	await SceneTransition.fade_in()
