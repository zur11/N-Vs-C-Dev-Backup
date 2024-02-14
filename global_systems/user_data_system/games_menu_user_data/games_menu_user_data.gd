class_name GamesMenuUserData extends Resource

@export var worlds :Array[World] 
@export var selected_world_index : int


#func get_current_level_index(level:Level) -> int:
	#var current_world : World = worlds[selected_world_index] as World 
	#var current_level_index : int
	##printt(current_world.levels)
	#
	#for current_world_level in current_world.levels as Array[Level]:
		#if current_world_level.level_name == level.level_name:
			#current_level_index = current_world.levels.find(current_world_level)
			#
			##printt("current level index: ", current_level_index)
			#
	#return current_level_index

