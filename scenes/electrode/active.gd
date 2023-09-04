# electrode active.gd
extends State


# Called when entering the Active state
func enter(_msg:= {}) -> void:
	_msg.animation_player.play(_msg.animation_name)
