class_name AllyCardSelector extends VBoxContainer

signal ally_selected(ally_name : String)
signal ally_card_loaded()
signal ally_card_finished_twinkling_process

var selected_card : AllyCard

#var _card_is_twinkling : bool
#var _full_color_int : int = 255
#var _empty_color_int : int = 0
#var _current_color_int : int
#var _color_int_is_decreasing : bool

func start_initial_display(ally_cards : Array[AllyCard]):
	for card in ally_cards:
		var ally_card : AllyCard = card
		self.add_child(ally_card)
		ally_card.initiate_card()
		ally_card.set_z_index(6)
		ally_card.connect("card_selected", _on_ally_card_selected)
		ally_card.connect("card_loaded", _on_ally_card_loaded)
		ally_card.card_stopped_twinkling.connect(_on_ally_card_stopped_twinkling)
		ally_card.card_unselected.connect(_on_ally_card_unselected)

func twinkle_ally_card(ally_card_index:int):
	var twinkling_card:AllyCard = get_child(ally_card_index) as AllyCard
	twinkling_card.is_twinkling = true
#	printt("is twinkling")
		

func disable_all_ally_card_buttons():
	for child in self.get_children():
		child.disabled = true

func enable_all_ally_card_buttons():
	for child in self.get_children():
		child.disabled = false

func start_selected_card_loading_process():
	selected_card.start_loading_process()

func update_cards_affordability(balance : int):
	for card in self.get_children():
		var ally_card : AllyCard = card as AllyCard
		if ally_card.price <= balance:
			ally_card.is_affordable = true
		else:
			ally_card.is_affordable = false

func _on_ally_card_stopped_twinkling():
	ally_card_finished_twinkling_process.emit()

func _on_ally_card_selected(_selected_card : AllyCard):
	if selected_card == _selected_card and selected_card != null:
		selected_card.is_selected = false
		selected_card = null
		ally_selected.emit("")
		return
		
	if selected_card != null and selected_card.is_selected:
		selected_card.is_selected = false

	selected_card = _selected_card
	ally_selected.emit(selected_card.ally.ally_name)

func _on_ally_card_unselected():
	selected_card = null
	ally_selected.emit("")

func _on_ally_card_loaded():
	ally_card_loaded.emit()

