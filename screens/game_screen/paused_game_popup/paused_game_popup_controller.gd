class_name PausedGamePopupController extends InputController

func _input(event):
	if InputControllersManager.selected_input_controller == self:
		if event is InputEventMouseMotion:
			_disable_keys_input_control()
			#get_viewport().set_input_as_handled()

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
				return
			if event is InputEventJoypadButton:
				focused_object.pressed.emit()
			return
		elif event.is_action("go_back"): # B KEY in Nintendo Controls
			containing_scene.on_cancel_input_received()
		elif event.is_action("move_left"):
			if focused_object_index > 0:
				if not focused_object is VolumeHorizontalSlider:
					focused_object = focusable_objects[focused_object_index - 1]
					containing_scene.on_left_input_received()
				else:
					return
		elif event.is_action("move_right"):
			if not focused_object is VolumeHorizontalSlider:
				var next_focusable_object : Control = focusable_objects[focused_object_index + 1]
				if focused_object_index < focusable_objects.size() - 1 and not next_focusable_object is VolumeHorizontalSlider:
					focused_object = next_focusable_object
					containing_scene.on_right_input_received()
			else:
				return
		elif event.is_action("move_up"):
			if focused_object is VolumeHorizontalSlider:
				if focused_object.bus_name == "SFX":
					focused_object = focusable_objects[focused_object_index + 1]
					containing_scene.on_up_input_received()
			else:
				for focusable_object in focusable_objects:
					if focusable_object is VolumeHorizontalSlider:
						if focusable_object.bus_name == "SFX":
							focused_object = focusable_object
							containing_scene.on_up_input_received()
		elif event.is_action("move_down"):
			if focused_object is VolumeHorizontalSlider:
				if focused_object.bus_name == "Music":
					for focusable_object in focusable_objects:
						if focusable_object is VolumeHorizontalSlider:
							if focusable_object.bus_name == "SFX":
								focused_object = focusable_object
								containing_scene.on_down_input_received()
				elif focused_object.bus_name == "SFX":
					focused_object = focusable_objects[0]
					containing_scene.on_down_input_received()
					
		focused_object.accept_event()
	else:
		if event is InputEventScreenTouch:
			_disable_keys_input_control()

