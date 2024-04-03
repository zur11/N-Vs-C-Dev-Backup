class_name RemoveAllyButton extends TextureButton

const _REMOVE_ALLY_BUTTON_TEXTURE_PATH : String = "res://screens/game_screen/remove_ally_button/assets/remove_ally_button.png"
const _SELECTED_REMOVE_ALLY_BUTTON_TEXTURE_PATH : String = "res://screens/game_screen/remove_ally_button/assets/remove_ally_button_selected.png"

var _remove_ally_button_texture : Texture = load(_REMOVE_ALLY_BUTTON_TEXTURE_PATH)
var _selected_remove_ally_button_texture : Texture = load(_SELECTED_REMOVE_ALLY_BUTTON_TEXTURE_PATH)

var is_selected : bool : set = _set_is_selected


func _set_is_selected(new_value:bool):
	is_selected = new_value
	_update_texture()

func _update_texture():
	if is_selected == true:
		self.texture_normal = _selected_remove_ally_button_texture
		self.texture_focused = _selected_remove_ally_button_texture
	else:
		self.texture_normal = _remove_ally_button_texture
		self.texture_focused = _remove_ally_button_texture

