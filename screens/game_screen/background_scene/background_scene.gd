class_name BackgroundScene extends Control

var level_index : int : set = _set_level_index

func _set_level_index(new_value:int):
	level_index = new_value
	
	if level_index == 0: return
	
	_set_initial_states()
	_connect_action_triggers()

func _connect_action_triggers():
	for action_trigger in get_tree().get_nodes_in_group("action_triggers") as Array[ActionTrigger]:
		action_trigger.action_triggered.connect(_on_action_trigger_triggered)

func _set_initial_states():
	get_tree().call_group("animatable_elements", "set_initial_state_animation", level_index)

func _on_action_trigger_triggered(action: Action):
	get_tree().call_group("animatable_elements", "play_animation", action.type)
