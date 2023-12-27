class_name StalingradSummerBg extends GamesMenuBg

@onready var _animation_player : AnimationPlayer = $AnimationPlayer

func animate_level_5_selected():
	_animation_player.play("_level_5_selected")
