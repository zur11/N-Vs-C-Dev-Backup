@tool
class_name LevelSelector extends Node2D

signal left_input_received
signal down_input_received
signal go_to_level(level:Level)
signal level_selected(level_int:int)

var _world: World 
var _level_group: Array[Level] 
var _selected_level : Level
var _games_menu_user_data : GamesMenuUserData
var _game_screen_user_data : GameScreenUserData

@onready var input_controller : LevelSelectorController = $LevelSelectorController as LevelSelectorController
@onready var scroll_card_container = $ScrollCardContainer
@onready var _cards_container = $%CardsContainer

var initial_focused_object : Control
var focusable_objects : Array[Control]

func initial_setup():
	_get_user_data()
	_connect_scroll_card_container_signals()
	display_selected_world_levels()

func set_input_controller():
	for card in _cards_container.get_children():
		if card is CenterContainer:
			focusable_objects.append(card.get_child(0))
	
	var selected_world : World = _games_menu_user_data.worlds[_games_menu_user_data.selected_world_index]
	initial_focused_object = focusable_objects[UserDataManager.get_current_level_index(selected_world.selected_level) - 1]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller


func on_left_input_received():
	left_input_received.emit()

func on_down_input_received():
	focusable_objects.clear()
	down_input_received.emit()

func display_selected_world_levels():
	_set_world(_games_menu_user_data.worlds[_games_menu_user_data.selected_world_index])
	_set_world_properties()
	_set_scroll_card_container()
	_on_level_card_selected(_world.selected_level)

func _get_user_data():
	_games_menu_user_data = UserDataManager.user_data.games_menu_user_data as GamesMenuUserData
	_game_screen_user_data = UserDataManager.user_data.game_screen_user_data as GameScreenUserData

func _connect_scroll_card_container_signals():
	scroll_card_container.connect("card_selected", _on_level_card_selected)
	scroll_card_container.connect("card_clicked", _on_level_card_pressed)
	
func _set_world(new_value: World):
	_world = new_value

func _set_world_properties():
	_level_group = _world.levels
	_selected_level = _world.selected_level

func _set_scroll_card_container():
	scroll_card_container.populate_card_container(_level_group)
	await get_tree().process_frame
	scroll_card_container.start_initial_setup(_selected_level)

func _update_user_data():
	UserDataManager.save_user_data_to_disk()

func _on_level_card_selected(new_value:Level):
	if _selected_level == new_value: return
	_selected_level = new_value
	_world.selected_level = _selected_level
	_update_user_data()
	level_selected.emit(int(_selected_level.level_name.trim_prefix("Level ")))

func _on_level_card_pressed(new_value: Level):
	if new_value == _selected_level:
		go_to_level.emit(_selected_level)
	else:
		scroll_card_container.move_to_clickled_level_card(new_value)

