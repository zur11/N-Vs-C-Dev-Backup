class_name AllyCardSlots extends Control

#Input Signals
signal cancel_key_input_received
signal right_exit_input_received
signal ally_unselected

@export var ally_slot_texture : Texture
var available_ally_slots : int : set = _set_available_ally_slots
var ally_slots_global_positions : Array[Vector2]
var selected_allies : Array[ChoosableAllyCard] 

@onready var _ally_slots_container : VBoxContainer = $AllySlotsContainer

#Input Variables
var _current_focused_object : TextureButton
var _last_focused_object : TextureButton

var test_color_rect : ColorRect = ColorRect.new()
@onready var input_controller : AllyCardSlotsController = $AllyCardSlotsController as AllyCardSlotsController

var replaced_slots : Array[AllySlot]
var focusable_objects : Array[Control]
var initial_focused_object : Control

var _scene_is_starting : bool


func _assign_selected_allies_to_ally_slots():
	if selected_allies.size() > 0:
		for ii in selected_allies.size():
			var ally_card = selected_allies[ii]
			
			for slot in _ally_slots_container.get_children() as Array[AllySlot]:
				if slot.get_index() > selected_allies.size() - 1:
					slot.assigned_ally_card = null
					break
					
				if slot.get_index() == ii:
					slot.assigned_ally_card = ally_card
	else:
		for slot in _ally_slots_container.get_children() as Array[AllySlot]:
			slot.assigned_ally_card = null

func toogle_ally_slot_visibility(slot_index:int, slot_visible:bool):
	var card_slot : AllySlot = _ally_slots_container.get_child(slot_index)
	var visible_color := Color(1,1,1,1)
	var invisible_color := Color(1,1,1,0)
	
	if slot_visible:
		card_slot.modulate = visible_color
	else:
		card_slot.modulate = invisible_color

func _set_available_ally_slots(new_value:int):
	available_ally_slots = new_value
	
	_add_available_ally_slots()
	await get_tree().create_timer(1).timeout
	_scene_is_starting = true
	set_input_controller()

func add_selected_ally(moveable_card:ChoosableAllyCard):
	selected_allies.append(moveable_card)
	_assign_selected_allies_to_ally_slots()
	_update_focusable_objects()

func delete_ally_from_selected_allies(moveable_card:ChoosableAllyCard):
	for ally_card in selected_allies:
		if ally_card == moveable_card:
			selected_allies.erase(ally_card)
	_assign_selected_allies_to_ally_slots()
	_update_focusable_objects()

func _update_focusable_objects():
	_disconnect_focusable_objects_signals()
	input_controller.disconnect_focusable_objects_signals()
	focusable_objects.clear()
	input_controller.focusable_objects.clear()
	for slot in _ally_slots_container.get_children() as Array[AllySlot]:
		if slot.assigned_ally_card != null:
			focusable_objects.append(slot.assigned_ally_card)
		else:
			focusable_objects.append(slot)
	
	input_controller.focusable_objects = focusable_objects
	_connect_focusable_objects_signals()
	input_controller.connect_focusable_objects_signals()

func _connect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if focusable_object != null:
			if not focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
				focusable_object.focus_entered.connect(_on_focusable_object_focus_entered.bind(focusable_object))
			if not focusable_object.focus_exited.is_connected(_on_focusable_object_focus_exited.bind(focusable_object)):
				focusable_object.focus_exited.connect(_on_focusable_object_focus_exited.bind(focusable_object))

func _disconnect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if focusable_object != null:
			if focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
				focusable_object.focus_entered.disconnect(_on_focusable_object_focus_entered.bind(focusable_object))
			if focusable_object.focus_exited.is_connected(_on_focusable_object_focus_exited.bind(focusable_object)):
				focusable_object.focus_exited.disconnect(_on_focusable_object_focus_exited.bind(focusable_object))

func _add_available_ally_slots():
	if _ally_slots_container.get_child_count() != 0:
		for child in _ally_slots_container.get_children():
			child.queue_free()
	
#	await get_tree().process_frame
	for ii in available_ally_slots:
		var ally_slot := load("res://screens/game_screen/allies_selector_popup/ally_card_slots/ally_slot/ally_slot.tscn").instantiate() as AllySlot
		ally_slot.texture_normal = ally_slot_texture
		
		_ally_slots_container.add_child(ally_slot)
		await get_tree().create_timer(0.1).timeout
		ally_slots_global_positions.append(ally_slot.global_position)

#Input Functions
func set_input_controller():
	if _scene_is_starting:
		input_controller.default_containing_scene = self
		if focusable_objects.size() == 0:
			for card_slot in _ally_slots_container.get_children():
				focusable_objects.append(card_slot)
				card_slot.focus_entered.connect(_on_focusable_object_focus_entered.bind(card_slot))
				card_slot.focus_exited.connect(_on_focusable_object_focus_exited.bind(card_slot))
				input_controller.focusable_objects = focusable_objects
				_scene_is_starting = false
			return
				
	if selected_allies.size() == 0:
		if input_controller.focused_object == null:
			initial_focused_object = focusable_objects[0]
			input_controller.containing_scene = self
		else:
			printt("Slots: ", input_controller.focused_object)
	else:
		for focusable_object in focusable_objects:
			if not focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
				focusable_object.focus_entered.connect(_on_focusable_object_focus_entered.bind(focusable_object))
			if not focusable_object.focus_exited.is_connected(_on_focusable_object_focus_exited.bind(focusable_object)):
				focusable_object.focus_exited.connect(_on_focusable_object_focus_exited.bind(focusable_object))
				

	if _last_focused_object != null:
		if not _last_focused_object is AllySlot: 
			initial_focused_object = _last_focused_object
		else:
			if _last_focused_object.assigned_ally_card != null:
				initial_focused_object = _last_focused_object.assigned_ally_card
			else:
				printt("Empty Ally Slots")
				initial_focused_object = _last_focused_object
	else:
		initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _update_last_focused_slot():
	_last_focused_object = _current_focused_object
	_current_focused_object = null

func _on_focusable_object_focus_entered(focused_object:Control):
	if not focused_object is AllySlot:
		for ally_slot in _ally_slots_container.get_children():
			if ally_slot.assigned_ally_card == focused_object:
				_current_focused_object = ally_slot
				_current_focused_object.assigned_ally_card.grab_focus()
		_update_last_focused_slot()
		return
		
	_current_focused_object = focused_object
	if _current_focused_object.assigned_ally_card != null:
		_current_focused_object.assigned_ally_card.grab_focus()
	
	if focused_object.assigned_ally_card != null:
		_update_last_focused_slot()
		focused_object.assigned_ally_card.grab_focus()
		return
	else:
		_current_focused_object.add_child(test_color_rect)
		test_color_rect.size = focused_object.size
		test_color_rect.color = Color(0,0,1,0.5)
		_update_last_focused_slot()

func _on_focusable_object_focus_exited(unfocused_object:Control):
	if unfocused_object is AllySlot and unfocused_object.get_child_count() != 0:
		unfocused_object.remove_child(test_color_rect)

func on_cancel_input_received():
	cancel_key_input_received.emit()

func on_right_exit_input_received():
	right_exit_input_received.emit()

func on_ally_card_unselected():
	ally_unselected.emit()
