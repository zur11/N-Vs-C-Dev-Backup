class_name Bullet extends CharacterBody2D

var bullet_sender : GameCharacter : set = _set_bullet_sender
var _inflicted_damage_points : int
var _is_moving_right : bool
var _has_been_shot : bool

func _physics_process(_delta):
	if _has_been_shot:
		if _is_moving_right:
			_move_right()
		else:
			_move_left()

func _set_bullet_sender(new_value:GameCharacter):
	bullet_sender = new_value
	
	if self is CannonBullet:
		_set_cannon_bullet_blast_connections(bullet_sender.cannon_number)
	else:
		_set_bullet_collision_and_visibility_settings()
		_set_inflicted_damage_points()
	
func _set_cannon_bullet_blast_connections(cannon_number:int):
	var _cannon_bullet_blast : Area2D = $BulletBlast
	
	_cannon_bullet_blast.body_entered.connect(_on_cannon_bullet_blast_body_entered)
	
	match cannon_number:
		1:
			_cannon_bullet_blast.set_collision_mask_value(2, true)
		2:
			_cannon_bullet_blast.set_collision_mask_value(4, true)
		3:
			_cannon_bullet_blast.set_collision_mask_value(6, true)
		4:
			_cannon_bullet_blast.set_collision_mask_value(8, true)
		5:
			_cannon_bullet_blast.set_collision_mask_value(10, true)

func start_movement_process():
	if bullet_sender.character_faction == "ally":
		_is_moving_right = true

	elif bullet_sender.character_faction == "enemy":
		$BulletTexture.flip_h = true
		_is_moving_right = false
	
	_has_been_shot = true

func _set_bullet_collision_and_visibility_settings():
	var _game_screen_user_data : GameScreenUserData = UserDataManager.user_data.game_screen_user_data
	var total_rows_number : int = _game_screen_user_data.total_rows_number
	var total_layers_number : int = total_rows_number * 2 
	
	for ii in total_layers_number * 2:
		if bullet_sender.get_collision_mask_value(ii+1) == true:
			self.set_collision_mask_value(ii+1, true)
	
	for ii in total_layers_number:
		if bullet_sender.get_z_index() == ii:
			self.set_z_index(ii)

func _set_inflicted_damage_points():
	_inflicted_damage_points = bullet_sender.damage_per_hit

func _move_right():
	var base_bullet_speed : float = 11.73
	self.position.x += base_bullet_speed
	
	if not self is CannonBullet:
		_check_for_bullet_receiver(base_bullet_speed)

func _move_left():
	var base_bullet_speed : float = -11.73
	self.position.x += base_bullet_speed
	
	_check_for_bullet_receiver(base_bullet_speed)

func _check_for_bullet_receiver(bullet_speed:float):
	var last_movement : KinematicCollision2D = self.move_and_collide(Vector2(bullet_speed,0), true)
	if last_movement != null:
		var damage_receiver : Object = last_movement.get_collider()
		if self is CannonBullet:
			#printt("Checking Bullet Receiver: ", damage_receiver.name)
			damage_receiver.auto_destroy()
		else:
			_inflict_damage_to_game_object(damage_receiver)
		_animate_impact()

func _inflict_damage_to_game_object(damage_receiver:Object):
	if self is IceBullet:
		damage_receiver.receive_damage(_inflicted_damage_points, "long_freezing")
		return
	
	damage_receiver.receive_damage(_inflicted_damage_points, "long_normal")

func _animate_impact():
	if not self is CannonBullet:
		self.queue_free()
		
func _on_cannon_bullet_blast_body_entered(body:Node2D):
	body.auto_destroy()
