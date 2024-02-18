class_name GamesMenuInputController extends InputController

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_ENTER:
				focused_object.pressed.emit()
			KEY_RIGHT:
				containing_scene.on_right_exit_input_received()

		focused_object.accept_event()
