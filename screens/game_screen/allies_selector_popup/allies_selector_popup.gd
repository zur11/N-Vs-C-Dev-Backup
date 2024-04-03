class_name AlliesSelectorPopup extends Control

signal allies_chosen(choosen_allies : Array[Ally])

const _CHOOSABLE_ALLY_CARD_SCENE_PATH : String = "res://screens/game_screen/allies_selector_popup/choosable_ally_card/choosable_ally_card.tscn"

@export var maximum_choosable_allies : int
var _all_level_allies : Array[Ally]
var _chosen_level_allies : Array[Ally]

var _unchosen_cards : Array[ChoosableAllyCard]
var _chosen_cards : Array[ChoosableAllyCard]

var _moveable_ally_cards : Array[ChoosableAllyCard]

var _ally_slots_are_full : bool

# INPUT CONTROL VARIABLES:
var focusable_objects : Array[Control]
var initial_focused_object : Control

@onready var input_controller : AlliesSelectorPopupController = $AlliesSelectorPopupController as AlliesSelectorPopupController

@onready var _start_game_button : TextureButton = $StartGameButton
@onready var _ally_card_slots : AllyCardSlots = $AllyCardSlots as AllyCardSlots
@onready var _allies_selector_scroll_container : AlliesSelectorScrollContainer = $AlliesSelectorScrollContainer as AlliesSelectorScrollContainer
@onready var _card_pressed_sfx_player : SFXPlayer = $CardPressedSFXPlayer as SFXPlayer
@onready var _generic_btn_pressed_player : SFXPlayer = $GenericBtnPressedPlayer as SFXPlayer


func _ready():
	_set_elements_z_index()
	_set_start_game_button()
	_connect_signals()
	
#	test_setup() Uncomment next line and add maximum_choosable_allies exportable variable up to 11.
#	_start_test_scene()
	

func _input(event: InputEvent):
	if event is InputEventScreenDrag:
		_update_grid_moveable_cards_positions()

func start_popup_input_control():
	_allies_selector_scroll_container.set_input_controller()


func _set_elements_z_index():
	_start_game_button.set_z_index(10)
	$BoxBordersTexture.set_z_index(7)

func _get_moveable_ally_card(ally:Ally) -> ChoosableAllyCard:
	var requested_card : ChoosableAllyCard
	for moveable_card in _moveable_ally_cards:
		if moveable_card.ally == ally:
			requested_card = moveable_card
	
	return requested_card

func _set_start_game_button():
	_start_game_button.modulate = Color(1,1,1,0.5)
	_start_game_button.disabled = true

func _connect_signals():
	_allies_selector_scroll_container.connect("grid_card_chosen", _on_scroll_container_grid_card_chosen)
	_allies_selector_scroll_container.left_exit_input_received.connect(_on_scroll_menu_left_exit_input_received)
	_allies_selector_scroll_container.cancel_key_input_received.connect(_on_scroll_menu_cancel_key_input_received)
	_ally_card_slots.right_exit_input_received.connect(_on_card_slots_right_exit_input_received)
	_ally_card_slots.cancel_key_input_received.connect(_on_card_slots_cancel_key_input_received)
	_ally_card_slots.ally_unselected.connect(_on_ally_card_slots_ally_unselected)

func _start_test_scene():
#	_ally_card_slots.available_ally_slots = maximum_choosable_allies
	var allies_scenes : Array[PackedScene] = [load("res://game_objects/allies/money_provider/matrioshka/matrioshka.tscn"), load("res://game_objects/allies/shooter_ally/bayonet_soldier/bayonet_soldier.tscn"), load("res://game_objects/allies/money_provider/matrioshka/matrioshka.tscn"), load("res://game_objects/allies/shooter_ally/bayonet_soldier/bayonet_soldier.tscn"), load("res://game_objects/allies/money_provider/matrioshka/matrioshka.tscn"), load("res://game_objects/allies/shooter_ally/bayonet_soldier/bayonet_soldier.tscn"), load("res://game_objects/allies/money_provider/matrioshka/matrioshka.tscn"), load("res://game_objects/allies/shooter_ally/bayonet_soldier/bayonet_soldier.tscn"), load("res://game_objects/allies/money_provider/matrioshka/matrioshka.tscn"), load("res://game_objects/allies/shooter_ally/bayonet_soldier/bayonet_soldier.tscn"), load("res://game_objects/allies/money_provider/matrioshka/matrioshka.tscn"), load("res://game_objects/allies/shooter_ally/bayonet_soldier/bayonet_soldier.tscn")]
	start_initial_display(allies_scenes)

func start_initial_display(allies_scenes : Array[PackedScene]):
	_ally_card_slots.available_ally_slots = maximum_choosable_allies
	
	for ii in allies_scenes.size():
		var ally_scene : PackedScene = allies_scenes[ii]
		var ally : Ally = ally_scene.instantiate() as Ally
		var grid_ally_card : ChoosableAllyCard = load(_CHOOSABLE_ALLY_CARD_SCENE_PATH).instantiate() as ChoosableAllyCard
		var moveable_ally_card : ChoosableAllyCard = load(_CHOOSABLE_ALLY_CARD_SCENE_PATH).instantiate() as ChoosableAllyCard
		
		_all_level_allies.append(ally)
		
		grid_ally_card.ally = ally
		moveable_ally_card.ally = ally
		_unchosen_cards.append(grid_ally_card)
		_allies_selector_scroll_container.add_card_to_choosable_cards_grid(grid_ally_card)
		_moveable_ally_cards.append(moveable_ally_card)
		
	await get_tree().create_timer(0.1).timeout
	_set_moveable_cards()

func set_input_controller():
	focusable_objects = [_start_game_button]

	initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller
	
func start_initial_test_display(allies_scenes : Array[PackedScene]):
	_ally_card_slots.available_ally_slots = maximum_choosable_allies
	
	for ii in allies_scenes.size():
		var ally_scene : PackedScene = allies_scenes[ii]
		var ally : Ally = ally_scene.instantiate() as Ally
		var grid_ally_card : ChoosableAllyCard = load(_CHOOSABLE_ALLY_CARD_SCENE_PATH).instantiate() as ChoosableAllyCard
		var moveable_ally_card : ChoosableAllyCard = load(_CHOOSABLE_ALLY_CARD_SCENE_PATH).instantiate() as ChoosableAllyCard
		
		_all_level_allies.append(ally)
		
		grid_ally_card.ally = ally
		moveable_ally_card.ally = ally
		_unchosen_cards.append(grid_ally_card)
		_allies_selector_scroll_container.add_card_to_choosable_cards_grid(grid_ally_card)
		_moveable_ally_cards.append(moveable_ally_card)
		
	await get_tree().create_timer(0.1).timeout
	_set_moveable_cards()

func _set_moveable_cards():
	for ii in _moveable_ally_cards.size():
		var moveable_card : ChoosableAllyCard = _moveable_ally_cards[ii]
		
		self.add_child(moveable_card)
		moveable_card.initialize_card()
		var grid_card : ChoosableAllyCard = _allies_selector_scroll_container.get_card_from_choosable_cards_grid(moveable_card.ally) 
		moveable_card.global_position = grid_card.global_position
		moveable_card.set_z_index(13)
		moveable_card.connect("pressed", _on_moveable_card_pressed.bind(moveable_card))
		
		moveable_card.visible = false


func _update_grid_moveable_cards_positions():
	for ii in _moveable_ally_cards.size():
		var moveable_card : ChoosableAllyCard = _moveable_ally_cards[ii]
		
		for jj in _unchosen_cards.size():
			var grid_card : ChoosableAllyCard = _unchosen_cards[jj]
			
			if moveable_card.ally == grid_card.ally:
				moveable_card.global_position = grid_card.global_position

func _update_moveable_cards_positions():
	var cards_global_positions : Array[Vector2] = _ally_card_slots.ally_slots_global_positions
	if _chosen_cards.size() == 0 : return

	for ii in _moveable_ally_cards.size():
		var moveable_card : ChoosableAllyCard = _moveable_ally_cards[ii]

		for jj in _chosen_cards.size():
			var selected_ally_card : ChoosableAllyCard = _chosen_cards[jj]
			if moveable_card.ally == selected_ally_card.ally:
				var tween = create_tween()

				tween.tween_property(moveable_card, "global_position", cards_global_positions[jj], 0.5)


func _disable_remaining_choosable_cards():
	for card in _unchosen_cards:
#		if not card.has_been_chosen:
		card.modulate = Color(1,1,1,0.5)
		card.disabled = true
	
	for card in _chosen_cards:
		card.modulate = Color(1,1,1,0.5)
		card.disabled = true

func _enable_chosen_moveable_cards():
	for card in _moveable_ally_cards:
		if card.has_been_chosen:
			card.disabled = false
			
func _enable_all_choosable_cards():
	for card in _moveable_ally_cards:
		if card.has_been_chosen:
			card.disabled = false
	
	for card in _unchosen_cards:
		card.modulate = Color(1,1,1,1)
		card.disabled = false

func _disable_all_choosable_cards():
	for card in _chosen_cards:
		card.disabled = true
	for card in _unchosen_cards:
		card.disabled = true
	for card in _moveable_ally_cards:
		card.disabled = true

#Edition
func _move_card_to_card_selector(moveable_card:ChoosableAllyCard, card_global_position:Vector2, card_index:int):
	moveable_card.has_been_chosen = true
	
	var tween = create_tween()
	
	_disable_all_choosable_cards()
	
	tween.tween_property(moveable_card, "global_position", card_global_position, 0.5)
	
	await get_tree().create_timer(0.5).timeout
	_ally_card_slots.toogle_ally_slot_visibility(card_index, false)
	
	if _chosen_cards.size() == maximum_choosable_allies:
		_ally_slots_are_full = true
		_disable_remaining_choosable_cards()
		_enable_chosen_moveable_cards()
		_start_game_button.modulate = Color(1,1,1,1)
		_start_game_button.disabled = false
		set_input_controller()
	
	else:
		_ally_slots_are_full = false
#		moveable_card.set_z_index(10)
		_enable_all_choosable_cards()
	

func _move_card_to_ally_selector_popup(moveable_card:ChoosableAllyCard):
	moveable_card.has_been_chosen = false
	
	for card in _chosen_cards:
		if card.ally == moveable_card.ally:
			var tween = create_tween()
			_disable_all_choosable_cards()

			tween.tween_property(moveable_card, "global_position", card.global_position, 0.5)
	await get_tree().create_timer(0.5).timeout
	_start_game_button.modulate = Color(1,1,1,0.5)
	_start_game_button.disabled = true
	
	#_enable_all_choosable_cards()
	moveable_card.visible = false

func _on_start_game_button_pressed():
	_generic_btn_pressed_player.play_sound()
	for chosen_card in _chosen_cards:
		for ally in _all_level_allies:
			if ally.ally_name == chosen_card.ally.ally_name:
				_chosen_level_allies.append(ally) 
	
	await get_tree().create_timer(1).timeout
	allies_chosen.emit(_chosen_level_allies)
	self.visible = false

func _on_scroll_container_grid_card_chosen(chosen_card:ChoosableAllyCard):
	for _chosen_card in _chosen_cards:
		if _chosen_card.ally == chosen_card.ally:
			return
			
	var moveable_card : ChoosableAllyCard
	
	_card_pressed_sfx_player.play_sound()
	
	_chosen_cards.append(chosen_card)
	_unchosen_cards.erase(chosen_card)
	
	for card in _moveable_ally_cards:
		if card.ally == chosen_card.ally:
			moveable_card = card
			var chosen_slot_index : int = _chosen_cards.size() - 1
			var chosen_slot_global_position : Vector2 = _ally_card_slots.ally_slots_global_positions[chosen_slot_index]
			
			moveable_card.visible = true
			
			
			chosen_card.modulate = Color(1,1,1,0.5)
			chosen_card.disabled = true

			_move_card_to_card_selector(moveable_card, chosen_slot_global_position, chosen_slot_index)
			await get_tree().create_timer(0.5).timeout
			_ally_card_slots.add_selected_ally(moveable_card)
			@warning_ignore("unassigned_variable")
			var chosen_moveable_cards : Array[ChoosableAllyCard]
			
			for ii in _chosen_cards.size():
				for jj in _moveable_ally_cards.size():
					if _chosen_cards[ii].ally == _moveable_ally_cards[jj].ally:
						chosen_moveable_cards.append(_moveable_ally_cards[jj])
			
			
			#_ally_card_slots.update_assigned_cards_in_slots(chosen_moveable_cards)
			
			
			

func _on_moveable_card_pressed(unchosen_card:ChoosableAllyCard):
	_card_pressed_sfx_player.play_sound()
	
	if _chosen_cards.size() != 0:
		for ii in _chosen_cards.size():
			var card : ChoosableAllyCard = _chosen_cards[ii]
			if card.ally == unchosen_card.ally:
				var new_available_slot_index = _chosen_cards.size() - 1

				_ally_card_slots.toogle_ally_slot_visibility(new_available_slot_index, true)
				_move_card_to_ally_selector_popup(unchosen_card)
				await get_tree().create_timer(0.5).timeout
				_unchosen_cards.append(card)
				_chosen_cards.erase(card)
				
				_enable_all_choosable_cards()
				#moveable_card.visible = false
				_ally_card_slots.delete_ally_from_selected_allies(unchosen_card)
				
				
				_update_moveable_cards_positions()
				break
	
	#await get_tree().create_timer(1).timeout
	#_ally_card_slots.update_assigned_cards_in_slots(_chosen_cards)


#Input Functions
func on_up_exit_input_received():
	_ally_card_slots.set_input_controller()

func on_cancel_key_input_received():
	_ally_card_slots.set_input_controller()

func _on_scroll_menu_left_exit_input_received():
	_ally_card_slots.set_input_controller()

func _on_scroll_menu_cancel_key_input_received():
	_ally_card_slots.set_input_controller()

func _on_card_slots_right_exit_input_received():
	_allies_selector_scroll_container.set_input_controller()

func _on_card_slots_cancel_key_input_received():
	if not _ally_slots_are_full:
		_allies_selector_scroll_container.set_input_controller()
	else:
		set_input_controller()
		
func _on_ally_card_slots_ally_unselected():
	_allies_selector_scroll_container.set_input_controller()
