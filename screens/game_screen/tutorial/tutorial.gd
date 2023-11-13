class_name Tutorial extends Node

signal tutorial_finished

@export var total_first_popup_pages : int = 1
@export var background_thumbnails : Array[Texture]
@export var ok_button_texture : Texture
@export var selected_ok_button_texture : Texture
@export var next_button_texture : Texture
@export var selected_next_button_texture : Texture
@export var base_popup_scene : PackedScene

var game_screen : GameScreen 
var _tutorial_popup : TutorialPopup

func _ready():
	_set_popup()
#	_initiate_popup()
	_connect_signals()

func _connect_signals():
	_tutorial_popup.first_popup_finished.connect(_on_first_tutorial_popup_finished)

func _connect_additional_signals():
	pass

func initiate_popup():
	_tutorial_popup.visible = true
	_tutorial_popup.update_popup_display()

func _set_popup():
	_tutorial_popup = base_popup_scene.instantiate() as TutorialPopup
	game_screen.add_child(_tutorial_popup)
	_tutorial_popup.set_z_index(14)
	_tutorial_popup.visible = false
	_tutorial_popup.position = Vector2(360,14)
	_tutorial_popup.total_first_popup_pages = total_first_popup_pages
	_tutorial_popup.background_thumbnails = background_thumbnails
	_tutorial_popup.next_button_texture = next_button_texture
	_tutorial_popup.selected_next_button_texture = selected_next_button_texture
	_tutorial_popup.ok_button_texture = ok_button_texture
	_tutorial_popup.selected_ok_button_texture = selected_ok_button_texture

func _set_extended_popup():
	pass
	
func _set_tutorial_twinkling_rows():
	pass

func on_tutorial_ally_added():
	pass

func _on_first_tutorial_popup_finished():
	_tutorial_popup.visible = false
	_tutorial_popup.queue_free()
	tutorial_finished.emit()
