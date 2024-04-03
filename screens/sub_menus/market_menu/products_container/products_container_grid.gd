class_name ProductsContainerGrid extends Control

signal product_button_pressed(product_button:BuyProductButton)

#Input Signals
signal cancel_input_received
signal right_exit_input_received

#var last_focused_object : Control

@onready var _grid_container : GridContainer = $GridContainer
@onready var input_controller : ProductsContainerController = $ProductsContainerController as ProductsContainerController

#Input Variables
var focusable_objects : Array[Control]
var initial_focused_object : Control

var _current_focused_product : BuyProductButton
var _last_focused_product : BuyProductButton

func _ready():
	_connect_buy_product_buttons()
	_set_focusable_objects()

func _connect_buy_product_buttons():
	for product_button in _grid_container.get_children():
		product_button.pressed.connect(_on_product_button_pressed.bind(product_button))
		product_button.focus_entered.connect(_on_focusable_object_focus_entered.bind(product_button))

func _set_focusable_objects():
	for product_button in _grid_container.get_children():
		focusable_objects.append(product_button)
	
	initial_focused_object = focusable_objects[0]

func _on_product_button_pressed(product_button:BuyProductButton):
	product_button_pressed.emit(product_button)

#Input Functions
func set_input_controller():
	for product in _grid_container.get_children() as Array[BuyProductButton]:
		if product is BuyProductButton:
			if not focusable_objects.has(product):
				focusable_objects.append(product)
	
	if _last_focused_product != null:
		initial_focused_object = _last_focused_product
	else:
		initial_focused_object = focusable_objects[0]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _update_last_focused_product():
	_last_focused_product = _current_focused_product
	_current_focused_product = null

func _on_focusable_object_focus_entered(focused_object:Control):
	_current_focused_product = focused_object
	_update_last_focused_product()

func on_cancel_input_received():
	cancel_input_received.emit()

func on_right_exit_input_received():
	right_exit_input_received.emit()


