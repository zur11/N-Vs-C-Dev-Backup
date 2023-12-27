extends Control

signal go_back

var _level_selector: LevelSelector
var _loading_new_world : bool

var background_scenes : Array[GamesMenuBg] 

@onready var background_scene : GamesMenuBg = $BackgroundScene as GamesMenuBg
@onready var _world_selector : WorldSelector = $WorldSelector


func _ready():
	_set_background_scenes()
	_set_world_selector()
	_set_level_selector()

func _set_background_scenes():
	var games_menu_user_data : GamesMenuUserData = UserDataManager.user_data.games_menu_user_data
	
	for ii in games_menu_user_data.worlds.size():
		var world_bg_scene : GamesMenuBg = games_menu_user_data.worlds[ii].games_menu_bg_scene.instantiate() as GamesMenuBg
		background_scenes.append(world_bg_scene)

func _set_world_selector():
	_world_selector.connect("world_selected", _on_world_selected_set_selected_world)
	_world_selector.initial_setup()

	_world_selector.position = Vector2(360,658)

func _set_level_selector():
	_level_selector = load("res://screens/sub_menus/games_menu/level_selector/level_selector.tscn").instantiate()
	self.add_child(_level_selector)
	_level_selector.initial_setup()
	_level_selector.position.y = -570
	
	await get_tree().create_timer(1).timeout
	
	var tween = create_tween()
	tween.tween_property(_level_selector, "position", Vector2(0, 0), 0.1).set_ease(Tween.EASE_OUT_IN)
	_level_selector.connect("go_to_level", _on_level_selector_go_to_level)
	_level_selector.connect("level_selected", _on_level_selector_level_selected)


func _get_current_background_scene(current_world:World) -> GamesMenuBg:
	var current_world_bg_scene : GamesMenuBg
	
	match current_world.world_name:
		"Stalingrad Summer":
			current_world_bg_scene = background_scenes[0]
		"Stalingrad Winter":
			current_world_bg_scene = background_scenes[1]
		"Budapest":
			current_world_bg_scene = background_scenes[2]
	
	return current_world_bg_scene

func real_replace_by(node_to_replace:Node, replacing_node: Node):
	var parent = node_to_replace.get_parent()
	var parent_children : Array[Node]= parent.get_children()
	var pos_in_parent : int = parent_children.find(node_to_replace)
	
	parent.remove_child(node_to_replace)
	parent.add_child(replacing_node)
	parent.move_child(replacing_node, pos_in_parent)

func _change_level_selector_display():
	if !_level_selector: return
	
	_loading_new_world = true
	
	_world_selector.disable_all_world_buttons()
	var tween = create_tween()
	tween.tween_property(_level_selector, "position", Vector2(0, -600), 0.5).set_ease(Tween.EASE_OUT_IN)
	
	await get_tree().create_timer(0.5).timeout
	_level_selector.display_selected_world_levels()
	
	var tween2 = create_tween()
	tween2.tween_property(_level_selector, "position", Vector2(0, 0), 0.5).set_ease(Tween.EASE_OUT_IN)
	
	await get_tree().create_timer(0.5).timeout
	
	_world_selector.enable_all_world_buttons()
	
	_loading_new_world = false

func _update_user_data(selected_level:Level):
	var games_menu_user_data : GamesMenuUserData = UserDataManager.user_data.games_menu_user_data
	var game_screen_user_data : GameScreenUserData = UserDataManager.user_data.game_screen_user_data
	
	var current_world : World = games_menu_user_data.worlds[games_menu_user_data.selected_world_index]
	
	for ii in current_world.levels.size():
		if current_world.levels[ii].level_name == selected_level.level_name:
			game_screen_user_data.current_level_index = ii
			game_screen_user_data.total_rows_number = current_world.total_rows_number
	
	UserDataManager.save_user_data_to_disk()

func _on_world_selected_set_selected_world(selected_world:World):
	var selected_world_bg_scene : GamesMenuBg = _get_current_background_scene(selected_world)
	#var selected_world_bg_scene : GamesMenuBg = _selected_world.games_menu_bg_scene.instantiate() as GamesMenuBg
	
	real_replace_by(background_scene, selected_world_bg_scene)
	background_scene = selected_world_bg_scene
	
	_change_level_selector_display()

func _on_level_selector_level_selected(level_int:int):
	match level_int:
		5:
			background_scene.animate_level_5_selected()

func _on_level_selector_go_to_level(level:Level):
	if not level.level_unlocked: return 
	var destiny_screen : GameScreen = load("res://screens/game_screen/game_screen.tscn").instantiate() as GameScreen
	destiny_screen.level = level.duplicate(true)
	
	var container_to_erase : SceneContainer = SceneManagerSystem.get_container_node("SubMenuContainer")

	_update_user_data(level)
	container_to_erase.unregister_in_system()
	SceneManagerSystem.get_container("ScreenContainer").goto_scene(destiny_screen)

func _on_go_back_button_pressed():
	if _loading_new_world: return
	
	$SFXPlayer.play_sound()
	_level_selector.queue_free()
	_world_selector.queue_free()
	go_back.emit()

