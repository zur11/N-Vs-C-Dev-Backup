class_name ProductPopup extends Control

signal buy_product_input_received(product_name:String, product_price:int)
signal cancel_input_received

@onready var _buy_button : TextureButton = $BuyButton
@onready var _cancel_button : TextureButton = $CancelButton
@onready var input_controller : ProductPopupController = $ProductPopupController as ProductPopupController
@onready var _product_thumbnail : Sprite2D = $ProductThumbnail
@onready var _pricetag_label : Label = $PricetagLabel
@onready var _description_label : Label = $DescriptionLabel

var _product_name : String
var _product_price : int

var focusable_objects : Array[Control]
var initial_focused_object : Control

var _current_focused_object : Control
var _last_focused_object : Control


func set_product(product_name:String ,product_texture:Texture, product_price:int, product_description:String):
	_product_name = product_name
	_product_thumbnail.texture = product_texture
	_product_price = product_price
	_pricetag_label.text = str(_product_price)
	_description_label.text = product_description

func set_input_controller():
	focusable_objects = [_cancel_button, _buy_button]
	_connect_focusable_objects_signals()
	if _last_focused_object != null:
		initial_focused_object = _last_focused_object
	else:
		initial_focused_object = focusable_objects[1]
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _connect_focusable_objects_signals():
	for focusable_object in focusable_objects:
		if not focusable_object.focus_entered.is_connected(_on_focusable_object_focus_entered.bind(focusable_object)):
			focusable_object.focus_entered.connect(_on_focusable_object_focus_entered.bind(focusable_object))

func _on_focusable_object_focus_entered(focused_object:Control):
	_current_focused_object = focused_object
	_update_last_focused_object()

func _update_last_focused_object():
	_last_focused_object = _current_focused_object
	_current_focused_object = null

func on_cancel_input_received():
	cancel_input_received.emit()

func _on_buy_button_pressed():
	buy_product_input_received.emit(_product_name, _product_price)

func _on_cancel_button_pressed():
	cancel_input_received.emit()
