class_name CardSelectorController extends InputController

var first_mouse_motion_input_already_received : bool
func _input(event):
	if InputControllersManager.selected_input_controller == self:
		if event is InputEventMouseMotion:
			if !focused_object == null:
				if !first_mouse_motion_input_already_received and event.position >= containing_scene.initial_focused_object.position and event.position < (containing_scene.initial_focused_object.position + containing_scene.initial_focused_object.size):
					return
				else:
					focused_object.release_focus()
					focused_object = null
					first_mouse_motion_input_already_received = true
					return
		elif event is InputEventKey or event is InputEventJoypadButton:
			if focused_object == null and event.pressed:
				containing_scene.set_input_controller()
				get_viewport().set_input_as_handled()

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion or event is InputEventScreenDrag:
		return

	if event.pressed:
		var focused_object_index : int = focusable_objects.find(focused_object)
		if event.is_action("display_pause_menu"): # START KEY in Nintendo Controls
			containing_scene.on_start_key_input_received()
		elif event.is_action("accept") or event is InputEventScreenTouch:
			if event is InputEventScreenTouch:
				_disable_keys_input_control()
				#return
			if event is InputEventJoypadButton:
				focused_object.pressed.emit()
			return
			#focused_object.pressed.emit()
		elif event.is_action("go_back"): # B KEY in Nintendo Controls
			containing_scene.on_cancel_input_received()
		elif event.is_action("select_last_coin"): # X KEY in Nintendo Controls
			containing_scene.on_coins_selection_key1_input_received()
		elif event.is_action("select_first_coin"): # Y KEY in Nintendo Controls
			containing_scene.on_coins_selection_key2_input_received()
		elif event.is_action("move_right"):
			containing_scene.on_right_exit_input_received()
		elif event.is_action("move_up"):
			if focused_object_index > 0:
				focused_object = focusable_objects[focused_object_index - 1]
			else:
				containing_scene.on_up_exit_input_received()
		elif event.is_action("move_down"):
			if focusable_objects.size() > 1:
				if focused_object_index < focusable_objects.size() - 1:
					focused_object = focusable_objects[focused_object_index + 1]
					
		focused_object.accept_event()
	else:
		if event is InputEventScreenTouch:
			_disable_keys_input_control()

