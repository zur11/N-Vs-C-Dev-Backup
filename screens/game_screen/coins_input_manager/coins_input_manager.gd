class_name CoinsInputManager extends Node

signal no_coins_to_select
signal cancel_input_received
signal left_input_received
signal right_input_received
signal up_input_received
signal down_input_received
signal start_key_input_received

var controller_is_focused : bool
var controller_lost_selection : bool
var focusable_coins : Array[RubleCoin]

var _current_focused_coin : RubleCoin : set = _set_current_focused_coin
var _last_focused_coin : RubleCoin

var test_color_rect : ColorRect = ColorRect.new()

func _set_current_focused_coin(new_value:RubleCoin):
	_current_focused_coin = new_value
	if _current_focused_coin != null:
		_current_focused_coin.grab_focus()

func control_coins_selection_input(key_number:int):
	match key_number:
		1:
			if _last_focused_coin != null:
				_current_focused_coin = _last_focused_coin
			else:
				_current_focused_coin = focusable_coins[0]
		2:
			if _last_focused_coin != null:
				_current_focused_coin = _last_focused_coin
			else:
				_current_focused_coin = focusable_coins[focusable_coins.size() - 1]
	controller_is_focused = true

func register_new_coin(coin:RubleCoin):
	focusable_coins.append(coin)
	coin.focus_entered.connect(_on_coin_focus_entered.bind(coin))
	coin.focus_exited.connect(_on_coin_focus_exited.bind(coin))
	coin.tree_exiting.connect(_on_coin_tree_exiting.bind(coin))
	coin.gui_input.connect(_on_coin_gui_input)

func _update_last_focused_object():
	_last_focused_coin = _current_focused_coin
	_current_focused_coin = null

func _check_coins_availability():
	if focusable_coins.size() == 0:
		controller_is_focused = false
		no_coins_to_select.emit()

func _disable_keys_input_control():
	if !_last_focused_coin == null:
		_last_focused_coin.release_focus()
	elif _current_focused_coin != null:
		_current_focused_coin.release_focus()
		
	_current_focused_coin = null
	_last_focused_coin = null

func _input(event):
	if controller_is_focused:
		if event is InputEventMouseMotion:
			_disable_keys_input_control()
			controller_lost_selection = true
	
		elif event is InputEventKey or event is InputEventJoypadButton:
			if controller_lost_selection and event.pressed:
				control_coins_selection_input(1)
				controller_lost_selection = false
			
				get_viewport().set_input_as_handled()

func _on_coin_gui_input(event:InputEvent):
	if event is InputEventMouseMotion or event is InputEventJoypadMotion or event is InputEventScreenDrag:
		return
		
	if event.pressed:
		var focused_object_index : int = focusable_coins.find(_current_focused_coin)
		if event.is_action("display_pause_menu"): # START KEY in Nintendo Controls
			_on_start_key_input_received()
		elif event.is_action("accept") or event is InputEventScreenTouch:
			if event is InputEventScreenTouch or event is InputEventMouseButton:
				_disable_keys_input_control()
				return
			if event is InputEventJoypadButton:
				_current_focused_coin.pressed.emit()
			return
			#_current_focused_coin.pressed.emit()
		elif event.is_action("go_back"): # B KEY in Nintendo Controls
			controller_is_focused = false
			cancel_input_received.emit()
			return
		elif event.is_action("select_last_coin"): # X KEY in Nintendo Controls
			if focusable_coins.size() - 1 > focused_object_index:
				_current_focused_coin = focusable_coins[focused_object_index + 1]
			elif focusable_coins.size() > 1:
				_current_focused_coin = focusable_coins[0]
			else:
				printt("There are not any more coins available at this moment")
				
			_current_focused_coin.accept_event()
			return
		elif event.is_action("select_first_coin"): # Y KEY in Nintendo Controls
			if focused_object_index > 0:
				_current_focused_coin = focusable_coins[focused_object_index - 1]
			elif focusable_coins.size() > 1:
				_current_focused_coin = focusable_coins[focusable_coins.size() - 1]
			else:
				print("There are not any more coins available at this moment")

			_current_focused_coin.accept_event()
			return
			
		elif event.is_action("move_left"):
			left_input_received.emit()
			controller_is_focused = false
			_current_focused_coin.accept_event()
		elif event.is_action("move_right"):
			right_input_received.emit()
			controller_is_focused = false
			_current_focused_coin.accept_event()
		elif event.is_action("move_up"):
			up_input_received.emit()
			controller_is_focused = false
			_current_focused_coin.accept_event()
		elif event.is_action("move_down"):
			down_input_received.emit()
			controller_is_focused = false
			_current_focused_coin.accept_event()
	else:
		if event is InputEventScreenTouch or event is InputEventMouseButton:
			_disable_keys_input_control()
			return

		#_current_focused_coin.accept_event()

func _on_coin_focus_entered(focused_coin:RubleCoin):
	_current_focused_coin = focused_coin
	
	_current_focused_coin.add_child(test_color_rect)
	test_color_rect.size = _current_focused_coin.size
	test_color_rect.color = Color(0,1,0,0.5)

func _on_coin_focus_exited(unfocused_coin:RubleCoin):
	unfocused_coin.remove_child(test_color_rect)

func _on_coin_tree_exiting(coin:RubleCoin):
	if coin == _current_focused_coin and controller_is_focused:
		if focusable_coins.size() > 1:
			var focused_coin_index : int = focusable_coins.find(coin)
			if focusable_coins.size() - 1 == focused_coin_index: 
				_current_focused_coin = focusable_coins[focused_coin_index - 1]
			else:
				_current_focused_coin = focusable_coins[focused_coin_index + 1]
		focusable_coins.erase(coin)
		_check_coins_availability()
	else:
		focusable_coins.erase(coin)

func _on_start_key_input_received():
	start_key_input_received.emit()
