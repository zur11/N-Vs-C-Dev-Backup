extends Node

@export var user_data : UserData  

func _init():
	user_data = UserDataPersistent.load_from_disk()
	
	if user_data.player_user_data.player_name == "":
		
		user_data.player_user_data.player_name = "Default User"
		user_data.player_user_data.player_balance = 300
		
		user_data.user_settings.music_enabled = true
		user_data.user_settings.sfx_enabled = true
		user_data.user_settings.music_volume_value = 0.5
		user_data.user_settings.sfx_volume_value = 0.5
		
		user_data.games_menu_user_data.worlds = [
			load("res://data/worlds/stalingrad_summer/stalingrad_summer.tres").duplicate(true) as World,
			load("res://data/worlds/stalingrad_winter/stalingrad_winter.tres").duplicate(true) as World,
			load("res://data/worlds/budapest/budapest.tres").duplicate(true) as World
			]
		user_data.games_menu_user_data.selected_world_index = 0
		
		for world in user_data.games_menu_user_data.worlds:
			if world.levels.size() != 0:
				world.selected_level = world.levels[0]
	
func save_user_data_to_disk():
	UserDataPersistent.save_to_disk(user_data)

func load_user_data_from_disk() -> UserData:
	return user_data


func set_background_scenes_in_all_levels():
	var worlds = user_data.games_menu_user_data.worlds
	
	for world in worlds:
		for level in world.levels:
			if level.background_scene_path != "":
				level.background_scene = load(level.background_scene_path)

func get_current_level_index(level:Level) -> int:
	var games_menu_user_data = user_data.games_menu_user_data
	var current_world : World = games_menu_user_data.worlds[games_menu_user_data.selected_world_index] as World 
	var current_level_index : int
	
	for current_world_level in current_world.levels as Array[Level]:
		if current_world_level.level_name == level.level_name:
			current_level_index = current_world.levels.find(current_world_level)
			
	return current_level_index + 1
