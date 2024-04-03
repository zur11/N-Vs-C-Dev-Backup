class_name GoToGamesMenuButton extends TextureButton

const _LABEL_TEXTURE_PATH : String = "res://screens/main_menu/assets/start_1.png"
const _SELECTED_LABEL_TEXTURE_PATH : String = "res://screens/main_menu/assets/start_2.png"

var _label_texture_img : Texture
var _selected_label_texture_img : Texture

@onready var _label_texture : TextureRect = $LabelTexture 

func _ready():
	_label_texture_img = load(_LABEL_TEXTURE_PATH)
	_selected_label_texture_img = load(_SELECTED_LABEL_TEXTURE_PATH)
	#pressed.connect(_on_focus_grabbed)
	mouse_entered.connect(_on_focus_grabbed)
	focus_entered.connect(_on_focus_grabbed)
	mouse_exited.connect(_on_focus_released)
	focus_exited.connect(_on_focus_released)
	
	
func _on_focus_grabbed():
	_label_texture.texture = _selected_label_texture_img

func _on_focus_released():
	_label_texture.texture = _label_texture_img
