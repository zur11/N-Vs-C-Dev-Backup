class_name Menus extends Node2D

var display_games_menu_directly : bool

var _games_menu_scene : PackedScene = load("res://screens/sub_menus/games_menu/games_menu.tscn")
var _settings_menu_scene : PackedScene = load("res://screens/sub_menus/settings_menu/settings_menu.tscn")
var _market_menu_scene : PackedScene = load("res://screens/sub_menus/market_menu/market_menu.tscn")

# World Icon Scenes Paths

const _STALINGRAD_SUMMER_ICON_PATH : String = "res://screens/sub_menus/games_menu/world_selector/world_buttons/world_icons/stalingrad_summer_icon/stalingrad_icon.tscn"
const _STALINGRAD_WINTER_ICON_PATH : String = "res://screens/sub_menus/games_menu/world_selector/world_buttons/world_icons/stalingrad_winter_icon/stalingrad_2_icon.tscn"
const _BUDAPEST_ICON_PATH : String = "res://screens/sub_menus/games_menu/world_selector/world_buttons/world_icons/budapest_icon/budapest_icon.tscn"

func _ready():
	($MainMenu as MainMenu).go_to_sub_menu.connect(_go_to_sub_menu)
	if display_games_menu_directly:
		_display_games_menu()
	else:
		_load_world_icons()
		#$SubMenuContainer.clear_container()

func _load_world_icons():
	var stalingrad_summer_icon : WorldIcon = load(_STALINGRAD_SUMMER_ICON_PATH).instantiate() as WorldIcon
	var stalingrad_winter_icon : WorldIcon = load(_STALINGRAD_WINTER_ICON_PATH).instantiate() as WorldIcon
	var budapest_icon : WorldIcon = load(_BUDAPEST_ICON_PATH).instantiate() as WorldIcon
	
	_add_world_icons_to_scene([stalingrad_summer_icon, stalingrad_winter_icon, budapest_icon])

func _add_world_icons_to_scene(world_icons:Array[WorldIcon]):
	for world_icon in world_icons:
		world_icon.visible = false
		add_child(world_icon)
		move_child(world_icon, 0)
		world_icon.visible = true

func _on_toggle_music_playing():
	MusicManager.play_main_stream()

func _go_to_sub_menu(sub_menu_name:String):
	var sub_menu:Node #= load("res://screens/sub_menus/"+ sub_menu_name+"/"+ sub_menu_name+".tscn").instantiate()

	if sub_menu_name == "settings_menu":
		sub_menu = _settings_menu_scene.instantiate() 
		sub_menu.connect("toogle_music_playing", _on_toggle_music_playing)
		SceneManagerSystem.get_container("SubMenuContainer").goto_scene(sub_menu)
	elif sub_menu_name == "games_menu":
		sub_menu = _games_menu_scene.instantiate() 
		SceneManagerSystem.get_container("SubMenuContainer").goto_scene(sub_menu)
	elif sub_menu_name == "market_screen":
		sub_menu = _market_menu_scene.instantiate() 
		SceneManagerSystem.get_container("LeftSubMenuContainer").goto_scene(sub_menu)

	await get_tree().create_timer(0.2).timeout
	
	var tween = create_tween()
	
	if sub_menu_name == "settings_menu" or sub_menu_name == "games_menu":
		tween.tween_property($".", "position", Vector2(-1920, 0), 0.5)
		($SubMenuContainer.get_child(0)).go_back.connect(go_to_main_menu)
	elif sub_menu_name == "market_screen":
		tween.tween_property($".", "position", Vector2(1920, 0), 0.5)
		($LeftSubMenuContainer.get_child(0)).go_back.connect(go_to_main_menu)



func go_to_main_menu():
	await get_tree().create_timer(0.2).timeout
	
	var tween = create_tween()
	tween.tween_property($".", "position", Vector2(0, 0), 0.5)

func _display_games_menu():
	var games_menu:Node = load("res://screens/sub_menus/games_menu/games_menu.tscn").instantiate()
	
	SceneManagerSystem.get_container("SubMenuContainer").goto_scene(games_menu)
	self.position = Vector2(-1920, 0)
	($SubMenuContainer.get_child(0)).go_back.connect(go_to_main_menu)
	
	
func _exit_tree():
	if $SubMenuContainer.get_child_count() != 0:
		if $SubMenuContainer.get_child(0).name == "SettingsMenu":
			$SubMenuContainer.get_child(0).update_saved_volume_settings()
			UserDataManager.save_user_data_to_disk()


func _on_load_background_scene_test_button_pressed():
	var _background_scene : PackedScene = load("res://screens/game_screen/background_scene/background_scene_w1/background_scene_w1.tscn")
