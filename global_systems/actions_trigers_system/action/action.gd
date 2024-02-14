class_name Action extends Node

enum Types {
	INITIAL_STATE,
	FIRST_WAVE_STARTED,
	LAST_WAVE_STARTED,
	OTHER_ACTION_ACTIVATED,
	COUNTER_REACH_FIVE
}

var type: Types

func _init(_type: Types = Types.FIRST_WAVE_STARTED):
	type = _type
