extends Node

var selected_input_controller : InputController : set = _set_selected_input_controller
var first_controller_set : bool = false

func _set_selected_input_controller(new_value:InputController):
	selected_input_controller = new_value
	
	if selected_input_controller != null and first_controller_set:
		_set_controller_focused_object()
		return
	
	if first_controller_set == false:
		_set_controller_focused_object()
		first_controller_set = true

func _set_controller_focused_object():
	if selected_input_controller.containing_scene.initial_focused_object != null:
		var next_focused_object : Control = selected_input_controller.containing_scene.initial_focused_object
		selected_input_controller.focused_object = next_focused_object



