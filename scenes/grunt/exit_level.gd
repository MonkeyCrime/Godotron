# grunt exit_level.gd
extends State


func enter(_msg:= {}) -> void:
	_msg.animation_player.play(_msg.animation_name)


# Called by the AnimationPlayer when animations are finished.
func notify(notify_data: Dictionary) -> void:
	var data = notify_data.get("animation_name")
	if (data != null && data == "exit_level"):
		print(owner.name, " exit level")
		Events.emit_signal(Constants.EVENT_ENEMY_DEAD, owner)
