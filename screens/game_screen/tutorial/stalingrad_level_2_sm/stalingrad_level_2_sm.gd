class_name StalingradLevel2Sm extends Tutorial

@export var tutorial_twinkling_rows : PackedScene

var _tutorial_twinkling_rows : TutorialTwinklingRows

func _ready():
	_set_popup()
	_set_tutorial_twinkling_rows()
	_connect_signals()
	_connect_additional_signals()

func _set_tutorial_twinkling_rows():
	_tutorial_twinkling_rows = tutorial_twinkling_rows.instantiate() as TutorialTwinklingRows
	
	game_screen.add_child(_tutorial_twinkling_rows)
	game_screen.move_child(_tutorial_twinkling_rows, game_screen.get_child_count() - 2)
	_tutorial_twinkling_rows.position = Vector2(207,170)
	_tutorial_twinkling_rows.set_twinkling_rows([2,3,4])

func _connect_additional_signals():
	game_screen.card_selector.ally_card_finished_twinkling_process.connect(_on_ally_card_stopped_twinkling)


func on_tutorial_ally_added():
	_remove_twinkling_rows_and_finish_tutorial()

func _remove_twinkling_rows_and_finish_tutorial():
	_tutorial_popup.visible = false
	_tutorial_twinkling_rows.queue_free()
	tutorial_finished.emit()

func _on_ally_card_stopped_twinkling():
	_twinkle_terrain_row()

func _twinkle_terrain_row():
	_tutorial_twinkling_rows.twinkle_rows([0,1,2])

func display_popup_and_remove_twinkling_rows():
	_tutorial_popup.visible = true
	_tutorial_popup.update_popup_display()
	_tutorial_twinkling_rows.queue_free()
#	level.tutorial_twinkling_rows = null

func _on_first_tutorial_popup_finished():
	_tutorial_popup.visible = false
	game_screen.card_selector.twinkle_ally_card(1)

