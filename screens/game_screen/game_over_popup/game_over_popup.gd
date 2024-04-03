class_name GameOverPopup extends Control

var level_to_replay : Level

var focusable_objects : Array[Control]
var initial_focused_object : Control
@onready var input_controller : GameOverPopupController = $GameOverPopupController as GameOverPopupController

@onready var _go_to_main_menu_button : TextureButton = $GoToMainMenuButton
@onready var _play_again_button : TextureButton = $PlayAgainButton

@onready var _generic_btn_pressed_player : SFXPlayer = $GenericBtnPressedPlayer as SFXPlayer

	
func set_input_controller():
	if focusable_objects == []:
		focusable_objects = [_go_to_main_menu_button, _play_again_button]

	initial_focused_object = focusable_objects[1]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func on_start_key_input_received():
	_on_play_again_button_pressed()

func on_cancel_input_received():
	_on_go_to_main_menu_button_pressed()

func _on_go_to_main_menu_button_pressed():
	var menus_screen : Node = load("res://screens/menus/menus.tscn").instantiate()
	
	_generic_btn_pressed_player.play_sound()
	await get_tree().create_timer(1).timeout
	
	get_tree().paused = false
	MusicManager.play_main_stream()
	SceneManagerSystem.get_container("ScreenContainer").goto_scene(menus_screen)


func _on_play_again_button_pressed():
	var destiny_screen : GameScreen = load("res://screens/game_screen/game_screen.tscn").instantiate() as GameScreen
	destiny_screen.level = level_to_replay
	
	_generic_btn_pressed_player.play_sound()
	await get_tree().create_timer(1).timeout
	
	get_tree().paused = false
	MusicManager.play_game_stream(level_to_replay)
	SceneManagerSystem.get_container("ScreenContainer").goto_scene(destiny_screen)
