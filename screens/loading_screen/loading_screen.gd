class_name LoadingScreen extends Control

var loading_animation_index = 0

const _MENUS_SCENE_PATH : String = "res://screens/menus/menus.tscn"
const _GAME_SCREEN_SCENE_PATH : String = "res://screens/game_screen/game_screen.tscn"
const _SETTINGS_MENU_SCENE_PATH : String = "res://screens/sub_menus/settings_menu/settings_menu.tscn"
const _GAMES_MENU_SCENE_PATH : String = "res://screens/sub_menus/games_menu/games_menu.tscn"

# BackgroundScenes Paths
const _STALINGRAD_SUMMER_BG_PATH : String = "res://screens/game_screen/background_scene/background_scene_w1/background_scene_w1.tscn"
const _STALINGRAD_WINTER_BG_PATH : String = "res://screens/game_screen/background_scene/background_scene_w2/background_scene_w2.tscn"

@onready var loading_animations_container := $"LoadingAnimationsContainer"

func _ready():
	MusicManager.play_main_stream()
	loading_animations_container.get_child(loading_animation_index).play_loading_animation(loading_animation_index, _MENUS_SCENE_PATH)
	for loading_animation in loading_animations_container.get_children():
		loading_animation.connect("loading_animation_ended",_play_next_animation)
		
func _play_next_animation():
	loading_animation_index += 1
	if loading_animation_index < loading_animations_container.get_child_count():
		if loading_animation_index == 1:
			loading_animations_container.get_child(loading_animation_index).play_loading_animation(loading_animation_index, _GAMES_MENU_SCENE_PATH)
		
		elif loading_animation_index == 2:
			loading_animations_container.get_child(loading_animation_index).play_loading_animation(loading_animation_index, _GAME_SCREEN_SCENE_PATH)
		
		elif loading_animation_index == 3:
			loading_animations_container.get_child(loading_animation_index).play_loading_animation(loading_animation_index, _STALINGRAD_WINTER_BG_PATH)
			
			_set_background_scenes_in_all_levels()
		
	else:
		var menus_screen : Node = load("res://screens/menus/menus.tscn").instantiate()
		
		await get_tree().create_timer(0.5).timeout
		
		SceneManagerSystem.get_container("ScreenContainer").goto_scene(menus_screen)
		SceneManagerSystem.get_container("CurtainSceneContainer").exit_scene()

func _set_background_scenes_in_all_levels():
	var stalingrad_summer_bg_scene : PackedScene = load(_STALINGRAD_SUMMER_BG_PATH)
	var stalingrad_winter_bg_scene : PackedScene = load(_STALINGRAD_WINTER_BG_PATH)
	UserDataManager.user_data.games_menu_user_data.set_background_scenes_in_all_levels([stalingrad_summer_bg_scene, stalingrad_winter_bg_scene])
