class_name CardSelectorController extends InputController

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventKey and event.pressed:
		
		var focused_object_index : int = focusable_objects.find(focused_object)
		match event.keycode:
			KEY_ENTER:
				focused_object.pressed.emit()
			KEY_LEFT:
				pass
					
			KEY_RIGHT:
				containing_scene.on_right_exit_input_received()

			KEY_UP:
				if focused_object_index > 0:
					focused_object = focusable_objects[focused_object_index - 1]
				else:
					containing_scene.on_up_exit_input_received()

			KEY_DOWN:
				if focusable_objects.size() > 1:
					if focused_object_index < focusable_objects.size() - 1:
						focused_object = focusable_objects[focused_object_index + 1]

		focused_object.accept_event()
