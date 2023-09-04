# electrode exit_level.gd
extends State


func enter(_msg:= {}) -> void:
	Events.emit_signal(Constants.EVENT_ENEMY_DEAD, owner)

