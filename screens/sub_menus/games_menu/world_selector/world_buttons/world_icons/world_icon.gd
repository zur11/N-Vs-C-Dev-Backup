class_name WorldIcon extends Sprite2D

@onready var _animation_player : AnimationPlayer = $AnimationPlayer

func play_selected_animation():
	_animation_player.play("_bw_to_color")

func play_unselected_animation():
	_animation_player.play("_color_to_bw")
