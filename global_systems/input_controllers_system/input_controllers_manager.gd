extends Node

var selected_input_controller : InputController : set = _set_selected_input_controller

func _set_selected_input_controller(new_value:InputController):
	selected_input_controller = new_value
	
	_set_controller_focused_object()

func _set_controller_focused_object():
	if selected_input_controller.containing_scene.initial_focused_object != null:
		var next_focused_object : Control = selected_input_controller.containing_scene.initial_focused_object
		selected_input_controller.focused_object = next_focused_object

		#if selected_input_controller.focused_object is AllyCard:
			#selected_input_controller.focused_object.is_selected = true
