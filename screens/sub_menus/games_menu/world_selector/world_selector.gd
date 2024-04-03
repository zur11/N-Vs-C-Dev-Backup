@tool
class_name WorldSelector extends Control

signal world_selected(world:World)
signal up_input_received
signal left_exit_input_received

@export var _games_menu_user_data : GamesMenuUserData

var _worlds : Array[World] 
var _selected_world_index : int

@onready var input_controller : WorldSelectorInputController = $WorldSelectorInputController as WorldSelectorInputController
@onready var _world_1_button : Button = $World1Button
@onready var _world_2_button : Button = $World2Button
@onready var _world_3_button : Button = $World3Button

var initial_focused_object : Control
var focusable_objects : Array[Control]
var selected_focusable_object : Control

func initial_setup():
	_get_user_data()
	_set_world_buttons()
	_set_initial_selected_world()

func set_input_controller():
	focusable_objects = [ _world_1_button, _world_2_button, _world_3_button]

	initial_focused_object = focusable_objects[_games_menu_user_data.selected_world_index]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func disable_all_world_buttons():
	for world_button in self.get_children():
		if world_button is TextureButton:
			world_button.disabled = true

func enable_all_world_buttons():
	for world_button in self.get_children():
		if world_button is TextureButton:
			world_button.disabled = false

func _get_user_data():
	var user_data : UserData = UserDataManager.user_data
	_games_menu_user_data = user_data.games_menu_user_data
	_worlds = _games_menu_user_data.worlds
	_selected_world_index = _games_menu_user_data.selected_world_index


func _set_world_buttons():
	for ii in self.get_child_count():
		if self.get_child(ii) is Button: 
			var world_button = self.get_child(ii) as WorldButton
			
			world_button.world = _worlds[ii]
			
			if ii == _selected_world_index:
				world_button.is_selected = true
			else:
				world_button.is_selected = false

			world_button.connect("pressed", _on_world_button_pressed.bind(ii))

func _set_initial_selected_world():
	_update_user_data()
	_set_selected_focusable_object()
	_emit_world_selected_signal(_worlds[_selected_world_index])

func _update_selected_world_index(new_value:int):
	var previous_selected_world_button = self.get_child(_selected_world_index) as WorldButton
	var selected_world_button = self.get_child(new_value) as WorldButton
	
	_selected_world_index = new_value
	
	previous_selected_world_button.is_selected = false
	selected_world_button.is_selected = true

func _update_user_data(): 
	_games_menu_user_data.selected_world_index = _selected_world_index

	UserDataManager.save_user_data_to_disk()

func _set_selected_focusable_object():
	var selected_world : World = _worlds[_selected_world_index]
	for world_button in self.get_children() as Array[WorldButton]:
		if world_button is WorldButton:
			if world_button.world == selected_world:
				selected_focusable_object = world_button

func on_left_exit_input_received():
	left_exit_input_received.emit()

func on_up_input_received():
	up_input_received.emit()

func _on_world_button_pressed(new_value:int):
	if new_value == _selected_world_index: return
	_update_selected_world_index(new_value)
	_update_user_data()
	_set_selected_focusable_object()
	_emit_world_selected_signal(_worlds[_selected_world_index])
	
func _emit_world_selected_signal(new_value:World):
	world_selected.emit(new_value)
	
func _exit_tree():
	if not Engine.is_editor_hint():
		_update_user_data()
