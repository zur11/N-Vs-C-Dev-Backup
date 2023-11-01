@tool
class_name BuyProductButton extends TextureButton

@export var product_name : String
@export var product_price : int
@export var product_thumbnail : Texture : set = _set_product_thumbnail 
@export var product_text : String : set = _set_product_text

@onready var _product_thumbnail : TextureRect = $ProductThumbnail
@onready var _product_label : Label = $ProductLabel

func _ready():
	_product_thumbnail.texture = product_thumbnail
	_product_label.text = product_text

func _set_product_thumbnail(new_value : Texture):
	product_thumbnail = new_value
	if _product_thumbnail != null:
		_product_thumbnail.texture = product_thumbnail
	
func _set_product_text(new_value : String):
	product_text = new_value
	if _product_label != null:
		_product_label.text = product_text
