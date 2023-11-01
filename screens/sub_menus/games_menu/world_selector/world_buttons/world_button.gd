class_name WorldButton extends Button

@export var world : World
@export var is_selected:bool :set = _set_is_selected

@onready var _world_icon : WorldIcon = $WorldIcon as WorldIcon

func _set_is_selected(new_value:bool):
	is_selected = new_value
	update_button_texture()

func update_button_texture():

	if is_selected:
		_world_icon.play_selected_animation()
	
	else:
		_world_icon.play_unselected_animation()

