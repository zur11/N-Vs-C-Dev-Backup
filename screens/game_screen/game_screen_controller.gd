class_name GameScreenController extends InputController

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER:
				focused_object.pressed.emit()
			KEY_LEFT:
				var focused_object_index : int = focusable_objects.find(focused_object)
				if focused_object_index > 0:
					focused_object = focusable_objects[focused_object_index - 1]
				else:
					containing_scene.on_left_exit_input_received()
					
			KEY_RIGHT:
				var focused_object_index : int = focusable_objects.find(focused_object)
				if focusable_objects.size() > 1:
					if focused_object_index < focusable_objects.size() - 1:
						focused_object = focusable_objects[focused_object_index + 1]
					#else:
						#focused_object = focusable_objects[0]

			KEY_UP:
				pass
			KEY_DOWN:
				containing_scene.on_down_exit_input_received()

		focused_object.accept_event()
