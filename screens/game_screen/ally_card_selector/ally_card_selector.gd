class_name AllyCardSelector extends VBoxContainer

signal ally_selected(ally_name : String)
signal ally_card_loaded()
signal ally_card_finished_twinkling_process
#Input Signals
signal cancel_input_received
signal up_exit_input_received
signal right_exit_input_received
signal coins_selection_key1_input_received
signal coins_selection_key2_input_received
signal start_key_input_received
signal keys_input_control_disabled

var _ally_cards : Array[AllyCard]
var selected_card : AllyCard

#Input Variables
var _current_focused_card : AllyCard
var _last_focused_card : AllyCard

var test_color_rect : ColorRect = ColorRect.new()
@onready var input_controller : CardSelectorController = $CardSelectorController as CardSelectorController

var focusable_objects : Array[Control]
var initial_focused_object : Control

func start_initial_display(ally_cards : Array[AllyCard]):
	_ally_cards = ally_cards
	for card in _ally_cards:
		var ally_card : AllyCard = card
		self.add_child(ally_card)
		ally_card.initiate_card()
		ally_card.set_z_index(6)
		ally_card.connect("card_selected", _on_ally_card_selected)
		ally_card.connect("card_loaded", _on_ally_card_loaded)
		ally_card.card_stopped_twinkling.connect(_on_ally_card_stopped_twinkling)
		ally_card.card_unselected.connect(_on_ally_card_unselected)

func twinkle_ally_card(ally_card_index:int):
	var twinkling_card:AllyCard = get_child(ally_card_index + 1) as AllyCard # +1 Because of CardSelector Controller
	twinkling_card.is_twinkling = true

func disable_all_ally_card_buttons():
	for card in _ally_cards:
		card.disabled = true

func enable_all_ally_card_buttons():
	for card in _ally_cards:
		card.disabled = false

func start_selected_card_loading_process():
	selected_card.start_loading_process()

func update_cards_affordability(balance : int):
	for card in _ally_cards:
		var ally_card : AllyCard = card as AllyCard
		if ally_card.price <= balance:
			ally_card.is_affordable = true
		else:
			ally_card.is_affordable = false

func _on_ally_card_stopped_twinkling():
	ally_card_finished_twinkling_process.emit()

func _on_ally_card_selected(_selected_card : AllyCard):
	if selected_card == _selected_card and selected_card != null:
		selected_card.is_selected = false
		selected_card = null
		ally_selected.emit("")
		return
		
	if selected_card != null and selected_card.is_selected:
		selected_card.is_selected = false

	selected_card = _selected_card
	ally_selected.emit(selected_card.ally.ally_name)

func _on_ally_card_unselected():
	selected_card = null
	ally_selected.emit("")

func _on_ally_card_loaded():
	ally_card_loaded.emit()

#Input Functions
func set_input_controller():
	for card in _ally_cards:
		
		if not focusable_objects.has(card):
			focusable_objects.append(card)
			card.focus_entered.connect(_on_focusable_object_focus_entered.bind(card))
			card.focus_exited.connect(_on_focusable_object_focus_exited.bind(card))

	if _last_focused_card != null:
		initial_focused_object = _last_focused_card
	else:
		initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _update_last_focused_card():
	_last_focused_card = _current_focused_card
	_current_focused_card = null

func _on_focusable_object_focus_entered(focused_object:Control):
	_current_focused_card = focused_object
	_current_focused_card.add_child(test_color_rect)
	test_color_rect.size = focused_object.size
	test_color_rect.color = Color(1,0,0,0.5)
	_update_last_focused_card()

func _on_focusable_object_focus_exited(unfocused_object:Control):
	unfocused_object.remove_child(test_color_rect)

func on_start_key_input_received():
	start_key_input_received.emit()

func on_cancel_input_received():
	cancel_input_received.emit()

func on_up_exit_input_received():
	up_exit_input_received.emit()

func on_right_exit_input_received():
	right_exit_input_received.emit()

func on_coins_selection_key1_input_received():
	coins_selection_key1_input_received.emit()

func on_coins_selection_key2_input_received():
	coins_selection_key2_input_received.emit()

