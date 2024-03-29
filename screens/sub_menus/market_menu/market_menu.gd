class_name MarketMenu extends Control

signal go_back

var _player_user_data : PlayerUserData = UserDataManager.user_data.player_user_data

@onready var input_controller : MarketMenuController = $MarketMenuController as MarketMenuController
@onready var _user_balance_displayer : UserBalanceDisplayer = $UserBalanceDisplayer as UserBalanceDisplayer
@onready var _products_container : ProductsContainer = $ProductsContainer as ProductsContainer
@onready var _go_back_button : TextureButton = $GoBackButton 

var focusable_objects : Array[Control]
var initial_focused_object : Control

func _ready():
	_update_user_balance_displayer()
	_connect_signals()

func set_input_controller():
	focusable_objects.append(_go_back_button)
	for focusable_object in _products_container.focusable_objects:
		focusable_objects.append(focusable_object)

	initial_focused_object = _products_container.initial_focused_object
	
	input_controller.containing_scene = self
	InputControllersManager.selected_input_controller = input_controller

func _connect_signals():
	_products_container.product_button_pressed.connect(_on_product_button_pressed)

func _update_user_balance_displayer():
	_user_balance_displayer.balance = _player_user_data.player_balance
	
func _on_go_back_button_pressed():
	$SFXPlayer.play_sound()
	focusable_objects.clear()
	go_back.emit()

func _on_product_button_pressed(product_button:BuyProductButton):
	if _player_user_data.player_balance < product_button.product_price:
		printt("Not enough balance")
		return
		
	if product_button.product_name == "7SlotsUpgrade":
		_player_user_data.unlocked_ally_slots = 7
	
	_player_user_data.player_balance -= product_button.product_price
	UserDataManager.save_user_data_to_disk()
	_update_user_balance_displayer()
