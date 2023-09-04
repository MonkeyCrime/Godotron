# family idle.gd
extends State


func enter(_msg := {}) -> void:
	var prefix = _msg.animation_prefix
	_msg.animation_player.play("%d_idle" % prefix)
