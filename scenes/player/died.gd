# died.gd
extends State

var animation_player: AnimationPlayer

func enter(_msg := {}) -> void:
	animation_player = _msg.animation_player
	animation_player.play("died")

	# Update lives
	Events.emit_signal(Constants.EVENT_UI_UPDATE_LIVES, {
		"lives" : owner.num_lives
	})
	
	await SceneTransition.fade_out(true)
	await SceneTransition.fade_in(true)

# Called by the AnimationPlayer when animations are finished.
func notify(notify_data:Dictionary) -> void:
	var data = notify_data.get("anim_name")
	if (data != null && data == "died"):
		owner.state_machine.transition_to("EnterLevel", {
		"animation_player" : animation_player
		} )
