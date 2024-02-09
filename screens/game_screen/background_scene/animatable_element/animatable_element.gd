class_name AnimatableElement extends AnimatedSprite2D

var action_type : Action.Types
var animation_name : String

func _ready():
	self.add_to_group("animatable_elements")

func set_initial_state_animation(current_level_index : int):
	action_type = _get_action_type()
	
	
	animation_name = Action.Types.find_key(action_type).to_lower() + "_l"+ str(current_level_index)

	if self.sprite_frames.has_animation(animation_name):
		self.animation = animation_name
	#else:
		#printt("Sprite Frames do not has: ", animation_name)

func _get_action_type() -> Action.Types:
	var animations : PackedStringArray = sprite_frames.get_animation_names()
	var actions : Array = Action.Types.keys()
	var _action_type : Action.Types 
	
	for anim in animations:
		for act_type in actions:
			if anim.to_upper().begins_with(act_type):
				_action_type = Action.Types[act_type]
	
	return _action_type

func play_animation(_action_type:Action.Types):
	if action_type == _action_type and self.sprite_frames.has_animation(animation_name):
		self.play(self.animation)


