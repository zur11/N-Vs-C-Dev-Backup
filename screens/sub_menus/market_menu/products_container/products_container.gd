@tool
class_name ProductsContainer extends HBoxContainer

signal product_button_pressed(product_button:BuyProductButton)

var focusable_objects : Array[Control]
var initial_focused_object : Control
var last_focused_object : Control

func _ready():
	if not Engine.is_editor_hint():
		_connect_buy_product_buttons()
		_set_focusable_objects()

func _connect_buy_product_buttons():
	for product_button in self.get_children():
		product_button.pressed.connect(_on_product_button_pressed.bind(product_button))

func _set_focusable_objects():
	for product_button in self.get_children():
		focusable_objects.append(product_button)
	
	initial_focused_object = focusable_objects[0]
	last_focused_object = focusable_objects[focusable_objects.size() - 1]

func _on_product_button_pressed(product_button:BuyProductButton):
	product_button_pressed.emit(product_button)
