class_name InputController extends Node

var containing_scene : Node : set = _set_containing_scene
var focusable_objects : Array[Control] 
var focused_object : Control : set = _set_focused_object

func _input(_event):
	pass

func _set_containing_scene(new_value:Node):
	containing_scene = new_value
	
	focusable_objects = containing_scene.focusable_objects

	connect_focusable_objects_signals()

func _set_focused_object(new_value:Control):
	focused_object = new_value
	if !focused_object == null:
		focused_object.grab_focus()

func disconnect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if focusable_object != null:
			if focusable_object.gui_input.is_connected(_on_input_event_key_pressed):
				focusable_object.gui_input.disconnect(_on_input_event_key_pressed) 

func connect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if focusable_object != null:
			if not focusable_object.gui_input.is_connected(_on_input_event_key_pressed):
				focusable_object.gui_input.connect(_on_input_event_key_pressed)

func _disable_keys_input_control():
	if !focused_object == null:
		focused_object.release_focus()
		focused_object = null

func _on_input_event_key_pressed(_event:InputEvent):
	pass
