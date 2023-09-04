# hulk idle.gd
extends State

func enter(_msg := {}) -> void:
	_msg.animation_player.play("idle")
