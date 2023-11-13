class_name TutorialPopup extends Control

signal tutorial_finished
signal first_popup_finished(tutorial_continues:bool)
signal second_popup_finished


var next_button_texture : Texture
var selected_next_button_texture : Texture

var total_first_popup_pages : int = 1
var total_second_popup_pages : int = 1

var has_two_popups : bool
var is_in_second_popup : bool

var ok_button_texture : Texture
var selected_ok_button_texture : Texture
var background_thumbnails : Array[Texture]
var second_popup_thumbnails : Array[Texture]
var _current_page : int = 1

@onready var _current_page_label : Label = $CurrentPageLabel
@onready var _continue_button : TextureButton = $ContinueButton
@onready var _background : TextureRect = $Background

#func _ready():
#	_update_continue_button_display()
#	_set_has_two_popups()
#	_update_current_page_label()

func update_popup_display():
	_set_has_two_popups()
	_update_continue_button_display()
	_update_background_texture()
	

func _update_continue_button_display():
	if not is_in_second_popup:
		if _current_page == total_first_popup_pages:
			_continue_button.texture_normal = ok_button_texture
			_continue_button.texture_pressed = selected_ok_button_texture
			_continue_button.texture_hover = selected_ok_button_texture
		else:
			_continue_button.texture_normal = next_button_texture
			_continue_button.texture_pressed = selected_next_button_texture
			_continue_button.texture_hover = selected_next_button_texture
	else:
		if _current_page == total_second_popup_pages:
			_continue_button.texture_normal = ok_button_texture
			_continue_button.texture_pressed = selected_ok_button_texture
			_continue_button.texture_hover = selected_ok_button_texture
		else:
			_continue_button.texture_normal = next_button_texture
			_continue_button.texture_pressed = selected_next_button_texture
			_continue_button.texture_hover = selected_next_button_texture

func _update_background_texture():
	if not is_in_second_popup:
		_background.texture = background_thumbnails[_current_page - 1]
	else:
		_background.texture = second_popup_thumbnails[_current_page - 1]

func _set_has_two_popups():
	if second_popup_thumbnails.size() != 0:
		has_two_popups = true

func _update_current_page_label():
	_current_page_label.text = "PAGE: " + str(_current_page)

func _on_continue_button_pressed():
	if not is_in_second_popup:
		if _current_page == total_first_popup_pages:
#			printt(has_two_popups)
			first_popup_finished.emit()
			
			if has_two_popups:
				is_in_second_popup = true
				_current_page = 1
			return
		
		_current_page += 1
		_update_current_page_label()
		_update_background_texture()
		_update_continue_button_display()
		
		if _current_page == total_first_popup_pages:
			_continue_button.texture_normal = ok_button_texture
			_continue_button.texture_pressed = selected_ok_button_texture
			_continue_button.texture_hover = selected_ok_button_texture
	else:
		if _current_page == total_second_popup_pages:
			second_popup_finished.emit()
			return
		
		_current_page += 1
		_update_current_page_label()
		_update_background_texture()
		_update_continue_button_display()
		
		if _current_page == total_second_popup_pages:
			_continue_button.texture_normal = ok_button_texture
			_continue_button.texture_pressed = selected_ok_button_texture
			_continue_button.texture_hover = selected_ok_button_texture
		
