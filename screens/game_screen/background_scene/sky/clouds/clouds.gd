class_name Clouds extends Node2D

@onready var _clouds_anim_player : AnimationPlayer = $CloudsAnimationPlayer as AnimationPlayer

func start_clouds_movement():
	_clouds_anim_player.play("clouds_loop")
