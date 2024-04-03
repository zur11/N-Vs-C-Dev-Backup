class_name RubleCoin extends TextureButton

signal picked_up

#var coin_value : int

var timer_wait_time : float : set = _set_timer_wait_time
var falling_time : float : set = _set_falling_time
var is_falling : bool

@onready var timer : Timer = $Timer

func _set_timer_wait_time(new_value:float):
	timer_wait_time = new_value
	timer.wait_time = timer_wait_time
	timer.start()

func _set_falling_time(new_value:float):
	falling_time = new_value
	is_falling = true
	var falling_timer : Timer = Timer.new()
	add_child(falling_timer)
	falling_timer.timeout.connect(_on_falling_timer_timeout)
	falling_timer.one_shot = true
	falling_timer.wait_time = falling_time
	falling_timer.start()

func _on_timer_timeout():
	self.queue_free()

func _on_falling_timer_timeout():
	is_falling = false

func _on_pressed():
	picked_up.emit()
	self.queue_free()
