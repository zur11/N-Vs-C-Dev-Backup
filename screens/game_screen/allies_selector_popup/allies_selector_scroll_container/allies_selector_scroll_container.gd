class_name AlliesSelectorScrollContainer extends ScrollContainer

signal grid_card_chosen(chosen_card:ChoosableAllyCard)

# Input Signals
signal cancel_key_input_received
signal left_exit_input_received

const _SCROLL_CONTAINER_THEME_PATH : String = "res://screens/game_screen/allies_selector_popup/allies_selector_scroll_container/scroll_container_theme.tres"

@export var vertical_scroll_grabber : Texture

#Input Variables
var focusable_objects : Array[Control]
var initial_focused_object : Control
#var test_color_rect : ColorRect = ColorRect.new()
var _current_focused_card : ChoosableAllyCard
var _last_focused_card : ChoosableAllyCard

@onready var input_controller : ScrollMenuController = $ScrollMenuController as ScrollMenuController

@onready var _vertical_scroll_bar : VScrollBar = $"_v_scroll" #self.get_v_scroll_bar()
@onready var _choosable_cards_grid : ChoosableCardsGrid = $"%ChoosableCardsGrid"

func _ready():
	_set_initial_variables()
	_connect_signals() 

func add_card_to_choosable_cards_grid(ally_card:ChoosableAllyCard):
	_choosable_cards_grid.add_and_connect_grid_card(ally_card)

func get_card_from_choosable_cards_grid(ally:Ally) -> ChoosableAllyCard:
	var requested_card : ChoosableAllyCard = _choosable_cards_grid.get_ally_card(ally)
	
	return requested_card

func _set_initial_variables():
	self.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	var scroll_container_theme : Theme = load(_SCROLL_CONTAINER_THEME_PATH)
	
	_vertical_scroll_bar.theme = scroll_container_theme
	_vertical_scroll_bar.set_z_index(50)

func _connect_signals():
	_choosable_cards_grid.connect("grid_card_pressed", _on_cards_grid_card_pressed)

func _on_cards_grid_card_pressed(pressed_card:ChoosableAllyCard):
	grid_card_chosen.emit(pressed_card)

#Input Functions
func set_input_controller():
	for card in _choosable_cards_grid.get_children() as Array[ChoosableAllyCard]:
		if card is ChoosableAllyCard:
			if not focusable_objects.has(card):
				focusable_objects.append(card)
				card.focus_entered.connect(_on_focusable_object_focus_entered.bind(card))
	
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
	_update_last_focused_card()

func on_cancel_input_received():
	cancel_key_input_received.emit()

func on_left_exit_input_received():
	left_exit_input_received.emit()
