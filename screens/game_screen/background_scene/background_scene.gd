class_name BackgroundScene extends Control

@onready var _clouds : Clouds = $Clouds as Clouds

func _ready():
	_clouds.start_clouds_movement()
	_connect_action_triggers()

func _connect_action_triggers():
	for action_trigger in get_tree().get_nodes_in_group("action_triggers") as Array[ActionTrigger]:
		action_trigger.action_triggered.connect(_on_action_trigger_triggered)

func _on_action_trigger_triggered(action: Action):
	get_tree().call_group("animatable_elements", "play_animation", action.type)
