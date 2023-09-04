# family exit_level.gd
extends State

var animation_player : AnimationPlayer


func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	animation_player.play(_msg.animation_name)


# Called by the AnimationPlayer when animations are finished.
func notify(notify_data:Dictionary) -> void:
	var data = notify_data.get("animation_name")
	if (data != null && data == "exit_level"):
		# Remove family member from the level
		Events.emit_signal(Constants.EVENT_ENEMY_DEAD, owner)
