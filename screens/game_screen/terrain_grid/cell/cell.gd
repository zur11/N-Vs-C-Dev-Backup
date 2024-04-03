class_name Cell extends TextureButton

var is_occupied : bool
var contained_coins : Array[RubleCoin]

func add_coin_to_cell(coin:RubleCoin):
	contained_coins.append(coin)
	coin.tree_exiting.connect(_on_contained_coin_tree_exiting.bind(coin))

func _on_contained_coin_tree_exiting(coin:RubleCoin):
	contained_coins.erase(coin)

