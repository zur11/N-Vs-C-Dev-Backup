@tool
class_name ProductsContainer extends HBoxContainer

signal product_button_pressed(product_button:BuyProductButton)

func _ready():
	_connect_buy_product_buttons()

func _connect_buy_product_buttons():
	for product_button in self.get_children():
		product_button.pressed.connect(_on_product_button_pressed.bind(product_button))

func _on_product_button_pressed(product_button:BuyProductButton):
	product_button_pressed.emit(product_button)
