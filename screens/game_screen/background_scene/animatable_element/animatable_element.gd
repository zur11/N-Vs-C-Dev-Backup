class_name AnimatableElement extends AnimatedSprite2D

@export var action_type : Action.Types
@export var sprite_frames_path: String


func _ready():
	set_process(false)
	self.add_to_group("animatable_elements")
	_start_threaded_sprite_frames_load()

func _process(_delta):
	if ResourceLoader.load_threaded_get_status(sprite_frames_path) == ResourceLoader.THREAD_LOAD_LOADED:
		set_process(false)
		_set_assigned_sprite_frames()

func _start_threaded_sprite_frames_load():
	if sprite_frames_path != "":
		ResourceLoader.load_threaded_request(sprite_frames_path)
		set_process(true)

func _set_assigned_sprite_frames():
	var assigned_sprite_frames : SpriteFrames = ResourceLoader.load_threaded_get(sprite_frames_path) as SpriteFrames
	self.sprite_frames = assigned_sprite_frames

func play_animation(_action_type:Action.Types):
	if action_type == _action_type:
		self.play(self.animation)


