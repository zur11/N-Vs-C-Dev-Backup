class_name LevelSelectorController extends InputController

func _input(event):
	if InputControllersManager.selected_input_controller == self:
		if event is InputEventMouseMotion:
			_disable_keys_input_control()
			containing_scene.on_focus_lost()

		elif event is InputEventKey or event is InputEventJoypadButton:
			if focused_object == null and event.pressed:
				containing_scene.set_input_controller()
				get_viewport().set_input_as_handled()

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion or event is InputEventScreenDrag:
		return
		
	if event.pressed:
		var focused_object_index : int = focusable_objects.find(focused_object)
		if event.is_action("accept") or event is InputEventScreenTouch:
			if event is InputEventScreenTouch:
				_disable_keys_input_control()
				return
			if focused_object != null:
				focused_object.get_child(0).pressed.emit()
			else:
				return

		elif event.is_action("move_left"):
			if focused_object_index > 0:
				focused_object = focusable_objects[focused_object_index - 1]
				if not focused_object.get_child(0).is_selected:
					focused_object.get_child(0).pressed.emit()
			else:
				containing_scene.on_left_input_received()

		elif event.is_action("move_right"):
			if focusable_objects.size() > 1:
				if focused_object_index < focusable_objects.size() - 1:
					focused_object = focusable_objects[focused_object_index + 1]
					if not focused_object.get_child(0).is_selected:
						focused_object.get_child(0).pressed.emit()

		elif event.is_action("move_down"):
			containing_scene.on_down_input_received()
		
		focused_object.accept_event()

	else:
		if event is InputEventScreenTouch:
			_disable_keys_input_control()

