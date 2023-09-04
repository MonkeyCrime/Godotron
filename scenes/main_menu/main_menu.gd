extends Control

func _ready() -> void:
	pass
	
func _on_start_pressed():
	#await SceneTransition.fade_out()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_exit_pressed():
	get_tree().quit()
