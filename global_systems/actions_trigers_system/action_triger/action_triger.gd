class_name ActionTrigger extends Node

signal action_triggered(action: Actions)

enum Actions {
	FIRST_WAVE_STARTED,
	LAST_WAVE_STARTED,
	OTHER_ACTION_ACTIVATED,
	COUNTER_REACH_FIVE
}

func _ready():
	add_to_group("action_triggers")
