class_name TwinklingRow extends TextureRect

var is_twinkling : bool : set = _set_is_twinkling
#var row_number : int
var _full_color_int : float = 1
var _empty_color_int : float = 0
var _current_color_float : float = 1
var _color_int_is_decreasing : bool


func _process(_delta):
	if is_twinkling:
		_twinkle()

func _set_is_twinkling(new_value):
	is_twinkling = new_value
	
	if is_twinkling:
		_color_int_is_decreasing = true
		
func _twinkle():
		if _color_int_is_decreasing:
			_current_color_float -= 0.03
			self.modulate = Color(_current_color_float, _full_color_int, _current_color_float)
			
			if _current_color_float <= _empty_color_int: _color_int_is_decreasing = false
		else:
			_current_color_float += 0.03
			self.modulate = Color(_current_color_float, _full_color_int, _current_color_float)
			
			if _current_color_float == _full_color_int: _color_int_is_decreasing = true


