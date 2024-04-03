class_name PausedGamePopup extends Control

signal cancel_input_received
signal start_key_input_received

var level_to_replay : Level

var _saved_settings := UserDataManager.user_data.user_settings

@onready var input_controller : PausedGamePopupController = $PausedGamePopupController as PausedGamePopupController
@onready var _music_horizontal_slider : HSlider = $"%MusicHorizontalSlider" 
@onready var _sfx_horizontal_slider : HSlider = $"%SFXHorizontalSlider"
@onready var _sfx_volume_selection_player : SFXPlayer = $SFXVolumeSelectionPlayer
@onready var _generic_btn_pressed_player : SFXPlayer = $GenericBtnPressedPlayer

@onready var _resume_game_button : TextureButton = $ResumeGameButton 
@onready var _retry_level_button : TextureButton = $RetryLevelButton
@onready var _go_to_main_menu_button : TextureButton = $GoToMainMenuButton

var focusable_objects : Array[Control]
var initial_focused_object : Control

var _current_focused_object : Control
var _last_focused_object : Control

func _ready():
	_set_volume_sliders()

func set_input_controller():
	if focusable_objects == []:
		focusable_objects = [_resume_game_button, _retry_level_button, _go_to_main_menu_button, _sfx_horizontal_slider, _music_horizontal_slider]

	for focusable_object in focusable_objects:
		if not focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
			focusable_object.focus_entered.connect(_on_focusable_object_focus_entered.bind(focusable_object))
			
	if _last_focused_object != null:
		initial_focused_object = _last_focused_object
	else:
		initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller
	
	_current_focused_object = initial_focused_object
	_update_last_focused_object()

func _update_last_focused_object():
	_last_focused_object = _current_focused_object
	_current_focused_object = null

func _set_volume_sliders():
	_music_horizontal_slider.sound_enabling_toggled.connect(_on_music_slider_sound_enabling_toggled)
	_sfx_horizontal_slider.sound_enabling_toggled.connect(_on_sfx_slider_sound_enabling_toggled)
	_music_horizontal_slider.value = _saved_settings.music_volume_value
	_sfx_horizontal_slider.value = _saved_settings.sfx_volume_value

func _update_saved_volume_settings():
	_saved_settings.music_volume_value = _music_horizontal_slider.value
	_saved_settings.sfx_volume_value = _sfx_horizontal_slider.value

func _hide_popup():
	_generic_btn_pressed_player.play_sound()
	get_tree().paused = false
	self.visible = false
	
func _on_music_slider_sound_enabling_toggled(sound_enabled:bool):
	_update_saved_volume_settings()
	
	_saved_settings.music_enabled = sound_enabled
	UserDataManager.save_user_data_to_disk()
	
	MusicManager.play_game_stream(level_to_replay)

func _on_sfx_slider_sound_enabling_toggled(sound_enabled:bool):
	_update_saved_volume_settings()
	
	_saved_settings.sfx_enabled = sound_enabled
	UserDataManager.save_user_data_to_disk()

func _on_focusable_object_focus_entered(focused_object:Control):
	_current_focused_object = focused_object

func on_start_key_input_received():
	_hide_popup()
	start_key_input_received.emit()

func on_left_input_received():
	_update_last_focused_object()

func on_right_input_received():
	_update_last_focused_object()

func on_up_input_received():
	_update_last_focused_object()

func on_down_input_received():
	_update_last_focused_object()
	
func on_cancel_input_received():
	_hide_popup()
	cancel_input_received.emit()

func _on_resume_game_button_pressed():
	_hide_popup()
	cancel_input_received.emit()


func _on_retry_level_button_pressed():
	var destiny_screen : GameScreen = load("res://screens/game_screen/game_screen.tscn").instantiate() as GameScreen
	destiny_screen.level = level_to_replay
	
	_generic_btn_pressed_player.play_sound()
	
	_update_saved_volume_settings()
	UserDataManager.save_user_data_to_disk()
	
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	MusicManager.play_game_stream(level_to_replay)
	SceneManagerSystem.get_container("ScreenContainer").goto_scene(destiny_screen)


func _on_go_to_main_menu_button_pressed():
	var menus_screen : Node = load("res://screens/menus/menus.tscn").instantiate()
	
	_generic_btn_pressed_player.play_sound()
	
	_update_saved_volume_settings()
	UserDataManager.save_user_data_to_disk()
	
	await get_tree().create_timer(1).timeout
	get_tree().paused = false
	MusicManager.play_main_stream()
	SceneManagerSystem.get_container("ScreenContainer").goto_scene(menus_screen)

func _on_sfx_horizontal_slider_drag_ended(_value_changed):
	_sfx_volume_selection_player.play_sound()

