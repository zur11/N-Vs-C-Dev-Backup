class_name TwinklingRow extends TextureRect

var is_twinkling : bool : set = _set_is_twinkling

var _minimum_alpha_float : float = 0.0
var _maximum_alpha_float : float = 1.0
var _current_alpha_float : float = _maximum_alpha_float
var _alpha_float_is_decreasing : bool

var _red_float : float = 0.761
var _green_float : float = 0.922 
var _blue_float : float = 0.525

func _process(_delta):
	if is_twinkling:
		_twinkle()
	else:
		self.modulate = Color(0,0,0,0)

func _set_is_twinkling(new_value):
	is_twinkling = new_value
	
	if is_twinkling:
		_alpha_float_is_decreasing = true
		
func _twinkle():
		if _alpha_float_is_decreasing:
			_current_alpha_float -= 0.02
			self.modulate = Color(_red_float, _green_float, _blue_float, _current_alpha_float)
			
			if _current_alpha_float <= _minimum_alpha_float: _alpha_float_is_decreasing = false
		else:
			_current_alpha_float += 0.02
			self.modulate = Color(_red_float, _green_float, _blue_float, _current_alpha_float)
			
			if _current_alpha_float >= _maximum_alpha_float: _alpha_float_is_decreasing = true


