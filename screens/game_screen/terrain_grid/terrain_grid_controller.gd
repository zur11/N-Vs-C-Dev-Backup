class_name TerrainGridController extends InputController

func _input(event):
	if InputControllersManager.selected_input_controller == self:
		if event is InputEventMouseMotion:
			_disable_keys_input_control()
			get_viewport().set_input_as_handled()

		elif event is InputEventKey or event is InputEventJoypadButton:
			if focused_object == null and event.pressed:
				containing_scene.set_input_controller()
				get_viewport().set_input_as_handled()

func _on_input_event_key_pressed(event:InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion or event is InputEventScreenDrag:
		return
	
	if not focused_object is Cell:
		return
		
	if event.pressed:
		var focused_object_index : int = focusable_objects.find(focused_object)
		if event.is_action("display_pause_menu"): # START KEY in Nintendo Controls
			containing_scene.on_start_key_input_received()
		elif event.is_action("accept") or event is InputEventScreenTouch:
			if event is InputEventMouseButton or event is InputEventScreenTouch:
				_disable_keys_input_control()
				return
			if focused_object.contained_coins.size() != 0:
				for coin in focused_object.contained_coins:
					if not coin.is_falling:
						coin.pressed.emit()
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
		elif event.is_action("move_left"):
			if not focused_object.name.ends_with("Col1"):
				focused_object = focusable_objects[focused_object_index - 1]
			else:
				containing_scene.on_left_exit_input_received()
		elif event.is_action("move_right"):
			if not focused_object.name.ends_with("Col9"):
				focused_object = focusable_objects[focused_object_index + 1]
		elif event.is_action("move_up"):
			if focused_object.name.begins_with("Row1"):
				containing_scene.on_up_exit_input_received()
			else:
				focused_object = focusable_objects[focused_object_index - 9]
		elif event.is_action("move_down"):
			if not focused_object.name.begins_with("Row5"):
				focused_object = focusable_objects[focused_object_index + 9]

		focused_object.accept_event()
	else:
		if event is InputEventMouseButton or event is InputEventScreenTouch:
			_disable_keys_input_control()

