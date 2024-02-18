class_name MainMenu extends Control

signal go_to_sub_menu(sub_menu_name: String)

var _player_user_data : PlayerUserData = UserDataManager.user_data.player_user_data

@onready var input_controller : MainMenuController = $MainMenuController as MainMenuController
@onready var _user_stats_container : UserStatsContainer = $UserStatsContainer

@onready var _go_to_games_menu_button : TextureButton = $GoToGamesMenuButton
@onready var _go_to_settings_menu_button : TextureButton = $GoToSettingsMenuButton
@onready var _go_to_market_button : TextureButton = $GoToMarketButton

var initial_focused_object : Control
var focusable_objects : Array[Control]

func _ready():
	_set_user_stats_container()
	set_input_controller()

func set_input_controller():
	focusable_objects.append(_go_to_market_button)
	focusable_objects.append(_go_to_games_menu_button)
	focusable_objects.append(_go_to_settings_menu_button)
	for focusable_object in _user_stats_container.focusable_objects:
		focusable_objects.append(focusable_object)
	
	#printt(focusable_objects)

	#focusable_objects = [ _go_to_market_button, _go_to_games_menu_button, _go_to_settings_menu_button, _user_stats_container]
	initial_focused_object = focusable_objects[1]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller
	
func _set_user_stats_container():
	_user_stats_container.user_name = _player_user_data.player_name
	_user_stats_container.user_balance = _player_user_data.player_balance


func _on_go_to_games_menu_button_pressed():
	go_to_sub_menu.emit("games_menu")
	$SFXPlayer.play_sound()

func _on_go_to_settings_menu_button_pressed():
	go_to_sub_menu.emit("settings_menu")
	$SFXPlayer.play_sound()


func _on_go_to_market_button_pressed():
	go_to_sub_menu.emit("market_screen")
	$SFXPlayer.play_sound()
