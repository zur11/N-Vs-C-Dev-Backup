class_name GamesMenuInputController extends InputController

func _input(event):
	if InputControllersManager.selected_input_controller == self:
		if event is InputEventMouseMotion:
			_disable_keys_input_control()

		elif event is InputEventKey or event is InputEventJoypadButton:
			if (event.is_action("move_up") or event.is_action("move_left")) and focused_object != null:
				get_viewport().set_input_as_handled()
			
			if focused_object == null and event.pressed:
				containing_scene.set_input_controller()
				get_viewport().set_input_as_handled()

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion or event is InputEventScreenDrag:
		return
		
	if event.pressed:
		if event.is_action("accept") or event is InputEventScreenTouch:
			if event is InputEventScreenTouch:
				_disable_keys_input_control()
				return
			if event is InputEventJoypadButton:
				focused_object.pressed.emit()
				
			return

		elif event.is_action("move_right"):
			containing_scene.on_right_exit_input_received()
			
		focused_object.accept_event()
	else:
		if event is InputEventScreenTouch:
			_disable_keys_input_control()
