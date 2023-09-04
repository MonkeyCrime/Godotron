# enforcer enter_level.gd
extends State

var player_node: Node2D


func enter(_msg:= {}) -> void:
	if _msg.is_empty():
		return
		
	_msg.animation_player.play(_msg.animation_name)
	player_node = _msg.player_node
	
	
func notify(notify_data:Dictionary) -> void:
	var data = notify_data.get("animation_name")
	if (data != null && data == "enter_level"):
		owner.state_machine.transition_to(Constants.STATENAME_ACTIVE, {
			"player_node" : player_node 
		} )
