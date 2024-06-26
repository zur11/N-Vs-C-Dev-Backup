class_name SmallMatrioshka extends MoneyProvider

const _COIN_SCENE_PATH : String = "res://game_objects/components/ruble_coin/ruble_coin.tscn"
var spawned_coin : RubleCoin

func adjust_location_in_cell():
	self.position = location_in_cell

func _get_random_wait_time() -> int:
	var random_number_generator := RandomNumberGenerator.new()
	
	var random_int =  random_number_generator.randi_range(18,23)
	return random_int

func _start_coin_drop_animation():
	_animation_player.play("_give_coin")
	_animation_player.queue("_idle")
	if not _animation_player.is_connected("animation_changed", _on_give_coin_anim_finished):
		_animation_player.connect("animation_changed", _on_give_coin_anim_finished)

func _spawn_new_coin():
	spawned_coin = load(_COIN_SCENE_PATH).instantiate() as RubleCoin
	
	self.add_child(spawned_coin)
	coin_spawned.emit(spawned_coin)
	
	spawned_coin.timer_wait_time = 5.5
	spawned_coin.position = Vector2(-41, -135)
	spawned_coin.connect("picked_up", _on_coin_picked_up)

func _on_coin_picked_up():
	coin_picked_up.emit()

func _on_give_coin_anim_finished(_old_name: StringName, _new_name: StringName):
	var wait_time = _get_random_wait_time()
	_timer.wait_time = wait_time
	_timer.start()

func _on_timer_timeout():
	_start_coin_drop_animation()
	await get_tree().create_timer(1.5).timeout
	_spawn_new_coin()
	
	assigned_cell.add_coin_to_cell(spawned_coin)
	spawned_coin.tree_exiting.connect(_on_spawned_coin_tree_exiting)

func _on_spawned_coin_tree_exiting():
	spawned_coin = null
