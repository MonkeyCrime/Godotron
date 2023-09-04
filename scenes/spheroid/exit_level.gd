# spheroid exit_level.gd
extends State


func enter(_msg:= {}) -> void:
	#print("spheroid ", owner.name, " exit level")
	Events.emit_signal(Constants.EVENT_ENEMY_DEAD, owner)
