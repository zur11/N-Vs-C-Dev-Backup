class_name TutorialTwinklingRows extends VBoxContainer

#signal row_stopped_twinkling(row_number:int)

var _activated_rows : Array[TextureRect]


func set_twinkling_rows(activated_rows_index_array : Array[int]):
	for activated_row_index in activated_rows_index_array:
		_activated_rows.append(self.get_child(activated_row_index - 1))
	
	for row_button in self.get_children():
		if not _activated_rows.has(row_button):
			row_button.modulate = Color(0,0,0,0)
			row_button.mouse_filter = TextureButton.MOUSE_FILTER_STOP
	
func twinkle_rows(rows_numbers:Array[int]):
	for row_number in rows_numbers:
		var twinkling_row:TwinklingRow = _activated_rows[row_number] as TwinklingRow
		twinkling_row.is_twinkling = true
		

#func _on_row_button_stopped_twinkling(row_index:int):
#	row_stopped_twinkling.emit(row_index + 1)
