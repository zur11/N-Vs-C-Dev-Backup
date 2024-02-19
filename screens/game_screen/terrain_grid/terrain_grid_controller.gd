class_name TerrainGridController extends InputController

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventKey and event.pressed:
		var focused_object_index : int = focusable_objects.find(focused_object)
		match event.keycode:
			KEY_ENTER:
				focused_object.pressed.emit()
			KEY_LEFT:
				if focused_object_index > 0:
					focused_object = focusable_objects[focused_object_index - 1]
				else:
					containing_scene.on_left_exit_input_received()
					
			KEY_RIGHT:
				if focusable_objects.size() > 1:
					if focused_object_index < focusable_objects.size() - 1:
						focused_object = focusable_objects[focused_object_index + 1]
					else:
						focused_object = focusable_objects[0]
			KEY_UP:
				if focused_object.name.begins_with("Row1"):
					containing_scene.on_up_exit_input_received()
				else:
					focused_object = focusable_objects[focused_object_index - 9]
			KEY_DOWN:
				if focused_object.name.begins_with("Row5"):
					pass
				else:
					focused_object = focusable_objects[focused_object_index + 9]

		focused_object.accept_event()
