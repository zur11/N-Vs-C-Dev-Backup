class_name StalingradLevel1Sm extends Tutorial

@export var total_second_popup_pages : int = 1
@export var second_popup_thumbnails : Array[Texture]
@export var tutorial_twinkling_rows : PackedScene

var _tutorial_twinkling_rows : TutorialTwinklingRows

func _ready():
	_set_popup()
	_set_extended_popup()
	_set_tutorial_twinkling_rows()
	_connect_signals()
	_connect_additional_signals()

func _set_extended_popup():
	_tutorial_popup.total_second_popup_pages = total_second_popup_pages
	_tutorial_popup.second_popup_thumbnails = second_popup_thumbnails

func _set_tutorial_twinkling_rows():
	_tutorial_twinkling_rows = tutorial_twinkling_rows.instantiate() as TutorialTwinklingRows
	
	game_screen.add_child(_tutorial_twinkling_rows)
	game_screen.move_child(_tutorial_twinkling_rows, game_screen.get_child_count() - 2)
	_tutorial_twinkling_rows.position = Vector2(207,170)
	_tutorial_twinkling_rows.set_twinkling_rows([2,3,4])

func _connect_additional_signals():
	game_screen.card_selector.ally_card_finished_twinkling_process.connect(_on_ally_card_stopped_twinkling)
	_tutorial_popup.second_popup_finished.connect(_on_second_tutorial_popup_finished)

func _on_ally_card_stopped_twinkling():
	_twinkle_terrain_row()

func _twinkle_terrain_row():
	_tutorial_twinkling_rows.twinkle_rows([0,1,2])

func on_tutorial_ally_added():
	_display_popup_and_remove_twinkling_rows()

func _display_popup_and_remove_twinkling_rows():
	_tutorial_popup.visible = true
	_tutorial_popup.update_popup_display()
	_tutorial_twinkling_rows.queue_free()

func _on_first_tutorial_popup_finished():
	_tutorial_popup.visible = false
	game_screen.card_selector.twinkle_ally_card(0)

func _on_second_tutorial_popup_finished():
	_tutorial_popup.visible = false
	_tutorial_popup.queue_free()
	tutorial_finished.emit()
