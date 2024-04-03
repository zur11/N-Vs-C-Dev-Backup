class_name SettingsMenu extends Control

signal go_back
signal toogle_music_playing

const _FLAG_STICK_TEXTURE_PATH : String = "res://screens/sub_menus/settings_menu/assets/flag_stick.png"
const _SELECTED_FLAG_STICK_TEXTURE_PATH : String = "res://screens/sub_menus/settings_menu/assets/flag_stick_selected.png"

@export var music_on_vslider_theme : Theme
@export var music_off_vslider_theme : Theme
@export var sfx_on_vslider_theme : Theme
@export var sfx_off_vslider_theme : Theme

var _saved_settings : UserSettings

var _music_flag_stick_texture : Texture
var _selected_music_flag_stick_texture : Texture
var _sfx_flag_stick_texture : Texture
var _selected_sfx_flag_stick_texture : Texture

@onready var input_controller : SettingsMenuController = $SettingsMenuController as SettingsMenuController
@onready var _sfx_vertical_slider : FlagVerticalSlider = $SFXVerticalSlider as FlagVerticalSlider

@onready var _music_vertical_slider : FlagVerticalSlider = $MusicVerticalSlider as FlagVerticalSlider
@onready var _sfx_volume_selection_player : SFXPlayer = $SFXVolumeSelectionPlayer as SFXPlayer
@onready var _go_back_button : TextureButton = $GoBackButton 

@onready var _music_flag_stick : TextureRect = $MusicFlagStick
@onready var _sfx_flag_stick : TextureRect = $SFXFlagStick

var initial_focused_object : Control
var focusable_objects : Array[Control]

var _settings_menu_is_active : bool
var selected_focusable_object : Control
var scene_is_starting : bool

func _ready():
	scene_is_starting = true
	_set_flag_stick_textures()
	_get_saved_user_settings()
	_set_volume_sliders()

func _set_flag_stick_textures():
	_music_flag_stick_texture = load(_FLAG_STICK_TEXTURE_PATH)
	_sfx_flag_stick_texture = load(_FLAG_STICK_TEXTURE_PATH)
	_selected_music_flag_stick_texture = load(_SELECTED_FLAG_STICK_TEXTURE_PATH)
	_selected_sfx_flag_stick_texture = load(_SELECTED_FLAG_STICK_TEXTURE_PATH)

func set_input_controller():
	_settings_menu_is_active = true
	
	focusable_objects = [_go_back_button, _music_vertical_slider, _sfx_vertical_slider]
	_connect_focusable_objects_signals()
	
	if scene_is_starting:
		initial_focused_object = focusable_objects[1]
		scene_is_starting = false
		selected_focusable_object = initial_focused_object
	else:
		initial_focused_object = selected_focusable_object
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _connect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if not focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
			focusable_object.focus_entered.connect(_on_focusable_object_focus_entered.bind(focusable_object))

func _on_focusable_object_focus_entered(focused_object:Control):
	selected_focusable_object = focused_object

func _get_saved_user_settings():
	_saved_settings = UserDataManager.user_data.user_settings

func _set_volume_sliders():
	_update_volume_sliders_themes()
	_music_vertical_slider.sound_enabling_toggled.connect(_on_music_slider_sound_enabling_toggled)
	_sfx_vertical_slider.sound_enabling_toggled.connect(_on_sfx_slider_sound_enabling_toggled)
	_music_vertical_slider.value = _saved_settings.music_volume_value
	_sfx_vertical_slider.value = _saved_settings.sfx_volume_value

func _update_volume_sliders_themes():
	if _saved_settings.music_enabled:
		_music_vertical_slider.theme = music_on_vslider_theme
	else:
		_music_vertical_slider.theme = music_off_vslider_theme
	
	if _saved_settings.sfx_enabled:
		_sfx_vertical_slider.theme = sfx_on_vslider_theme
	else:
		_sfx_vertical_slider.theme = sfx_off_vslider_theme


func _on_music_slider_sound_enabling_toggled(sound_enabled:bool):
	update_saved_volume_settings()
	
	_saved_settings.music_enabled = sound_enabled
	_update_volume_sliders_themes()
	UserDataManager.save_user_data_to_disk()

	toogle_music_playing.emit()

func _on_sfx_slider_sound_enabling_toggled(sound_enabled:bool):
	update_saved_volume_settings()
	
	_saved_settings.sfx_enabled = sound_enabled
	_update_volume_sliders_themes()
	UserDataManager.save_user_data_to_disk()

func update_saved_volume_settings():
	_saved_settings.music_volume_value = _music_vertical_slider.value
	_saved_settings.sfx_volume_value = _sfx_vertical_slider.value

func _on_go_back_button_pressed():
	update_saved_volume_settings()
	UserDataManager.save_user_data_to_disk()
	$GoBackBtnSFXPlayer.play_sound()
	go_back.emit()


func _on_sfx_vertical_slider_drag_ended(_value_changed):
	_sfx_volume_selection_player.play_sound()

func _on_music_flag_stick_focus_entered():
	_music_flag_stick.texture = _selected_music_flag_stick_texture

func _on_music_flag_stick_focus_exited():
	_music_flag_stick.texture = _music_flag_stick_texture

func _on_music_flag_stick_mouse_entered():
	_music_flag_stick.texture = _selected_music_flag_stick_texture

func _on_music_flag_stick_mouse_exited():
	_music_flag_stick.texture = _music_flag_stick_texture

func _on_sfx_flag_stick_focus_entered():
	_sfx_flag_stick.texture = _selected_sfx_flag_stick_texture

func _on_sfx_flag_stick_focus_exited():
	_sfx_flag_stick.texture = _sfx_flag_stick_texture

func _on_sfx_flag_stick_mouse_entered():
	_sfx_flag_stick.texture = _selected_sfx_flag_stick_texture

func _on_sfx_flag_stick_mouse_exited():
	_sfx_flag_stick.texture = _sfx_flag_stick_texture
