extends CanvasLayer

func _ready():
	pass

func fade_in(from_death: bool = false) -> void:
	var animation_name = "dissolve_red" if from_death else "dissolve"
	$AnimationPlayer.play_backwards(animation_name)
	await $AnimationPlayer.animation_finished

	
func fade_out(from_death: bool = false) -> void:
	var animation_name = "dissolve_red" if from_death else "dissolve"
	$AnimationPlayer.play(animation_name)
	await $AnimationPlayer.animation_finished
