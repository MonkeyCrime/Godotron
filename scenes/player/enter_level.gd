# player enter_level.gd
extends State

func enter(_msg := {}) -> void:
	_msg.animation_player.play("enter_level")

func notify(notify_data:Dictionary) -> void:
	var data = notify_data.get("anim_name")
	if (data != null && data == "enter_level"):
		Events.emit_signal(Constants.EVENT_PLAYER_ENTRY_COMPLETE)
