class_name MainMenu extends Control

signal go_to_sub_menu(sub_menu_name: String)

var _player_user_data : PlayerUserData = UserDataManager.user_data.player_user_data

@onready var input_controller : MainMenuController = $MainMenuController as MainMenuController
@onready var _user_stats_container : UserStatsContainer = $UserStatsContainer as UserStatsContainer

@onready var _go_to_games_menu_button : TextureButton = $GoToGamesMenuButton
@onready var _go_to_settings_menu_button : TextureButton = $GoToSettingsMenuButton
@onready var _go_to_market_button : TextureButton = $GoToMarketButton


var selected_focusable_object : Control
var initial_focused_object : Control
var focusable_objects : Array[Control]

func _ready():
	_set_user_stats_container()
	set_input_controller()

func set_input_controller():
	focusable_objects = [_go_to_market_button, _go_to_games_menu_button, _go_to_settings_menu_button, _user_stats_container.display_stats_button]
	_connect_focusable_objects_signals()
	
	initial_focused_object = focusable_objects[1]
	selected_focusable_object = initial_focused_object
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _connect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if not focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
			focusable_object.focus_entered.connect(_on_focusable_object_focus_entered.bind(focusable_object))

func _set_user_stats_container():
	_user_stats_container.user_name = _player_user_data.player_name
	_user_stats_container.user_balance = _player_user_data.player_balance

func _on_focusable_object_focus_entered(focused_object:Control):
	selected_focusable_object = focused_object

func _on_go_to_games_menu_button_pressed():
	go_to_sub_menu.emit("games_menu")
	$SFXPlayer.play_sound()

func _on_go_to_settings_menu_button_pressed():
	go_to_sub_menu.emit("settings_menu")
	$SFXPlayer.play_sound()

func _on_go_to_market_button_pressed():
	go_to_sub_menu.emit("market_screen")
	$SFXPlayer.play_sound()

