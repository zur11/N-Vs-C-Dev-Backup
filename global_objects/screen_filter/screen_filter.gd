class_name ScreenFilter extends TextureRect


func toogle_filter_visibility(set_filter_visible:bool):
	if set_filter_visible:
		var tween : Tween = create_tween()
		
		tween.tween_property($".", "modulate", Color(1,1,1,1), 1)
	else:
		self.modulate = Color(0,0,0,0)
		#var tween : Tween = create_tween()
		#tween.tween_property($".", "modulate", Color(0,0,0,0), 1)
