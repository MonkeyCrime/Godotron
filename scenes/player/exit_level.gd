# exit_level.gd
extends State

func enter(_msg := {}) -> void:
	_msg.animation_player.play("exit_level")

# Called by the AnimationPlayer when animations are finished.
func notify(notify_data:Dictionary) -> void:
	var data = notify_data.get("anim_name")
	if (data != null && data == "exit_level"):
		Events.emit_signal(Constants.EVENT_PLAYER_EXIT_COMPLETE)
