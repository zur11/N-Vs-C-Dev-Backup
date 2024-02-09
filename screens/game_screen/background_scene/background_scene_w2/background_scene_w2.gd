class_name BackgroundSceneW2 extends BackgroundScene

@onready var _clouds : Clouds = $Clouds

func _ready():
	_clouds.start_clouds_movement()
