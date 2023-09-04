# spheroid idle.gd
extends State


func enter(_msg:= {}) -> void:
	if _msg == null or _msg.is_empty():
		return
		
	_msg.animation_player.play(_msg.animation_name)
