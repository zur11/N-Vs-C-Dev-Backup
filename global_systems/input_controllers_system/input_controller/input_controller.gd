class_name InputController extends Node

var containing_scene : Node : set = _set_containing_scene
var focusable_objects : Array[Control] 
var focused_object : Control : set = _set_focused_object

func _set_containing_scene(new_value:Node):
	containing_scene = new_value
	
	focusable_objects = containing_scene.focusable_objects

	_connect_focusable_objects_signals()

func _set_focused_object(new_value:Control):
	focused_object = new_value
	focused_object.grab_focus()

func _connect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if focusable_object != null:
			if not focusable_object.gui_input.is_connected(_on_input_event_key_pressed):
				focusable_object.gui_input.connect(_on_input_event_key_pressed)

func _on_input_event_key_pressed(_event:InputEvent):
	pass
