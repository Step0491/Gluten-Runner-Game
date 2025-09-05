extends CharacterBody3D

# Costanti
const LANES: Array = [-1.4, 0, 1.4]
const ACCELERATION: float = 0.4

# SISTEMA TOUCH DELL'AMICO - INIZIO
var swipeLength = 15
var startSwipe: Vector2
var curSwipe: Vector2
var swiping = false
var threshold = 15
var swipeDir = 0
# SISTEMA TOUCH DELL'AMICO - FINE

# Variabili
var GRAVITY: float = 28.0
var speed: float = 8.0
var JUMP_VELOCITY: float = 9.0

var starting_point: Vector3 = Vector3.ZERO	
var current_lane: int = 1
var target_lane: int = 1

var max_health: int = 100
var health: int = 100
var is_dead: bool = false

var target_z: float = 0.0
var z_recovery_speed: float = 10.0
var max_z_reached: float = 0.0
var has_jumped: bool = true  # Per gestire il messaggio in salto
var ok = false 

# Segnali
signal hit
signal food
signal food_entered
signal dead

# Funzione chiamata alla morte del personaggio
func die() -> void:
	if is_dead:
		return
	is_dead = true
	dead.emit()
	$SubViewport/ProgressBar.hide()
	get_parent().game_over()

# Aggiorna la barra della salute
func update_health_bar() -> void:
	$SubViewport/ProgressBar.value = health

# Ritorna salute corrente
func life() -> int:
	return health

# Ricezione danno
func take_damage(damage: int) -> void:
	if is_dead:
		return
	health -= damage
	health = clamp(health, 0, max_health)
	update_health_bar()
	if health == 0:
		die()
		
func gain_life(point: int) -> void:
	if is_dead:
		return
	if health <100:
		health += point
		health = clamp(health, 0, max_health)
		update_health_bar()

# Inizializzazione
func _ready() -> void:
	starting_point = global_transform.origin
	target_z = starting_point.z
	max_z_reached = starting_point.z
	add_to_group("player")
	
# Controlla se il cambio corsia è possibile
func can_move_to_lane(lane_index: int) -> bool:
	if lane_index < 0 or lane_index >= LANES.size():
		return false

	var from = global_transform.origin
	var to = Vector3(LANES[lane_index], from.y, from.z)

	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(from, to)
	ray_params.collision_mask = 0b100  # layer 3
	ray_params.exclude = [self]

	var result = space_state.intersect_ray(ray_params)
	return result.is_empty()


func get_swipe_angle(start: Vector2, end: Vector2) -> float:
	var delta = end - start
	delta.y *= -1  # Inverti Y per usare un sistema con Y che cresce verso l'alto
	var angle = rad_to_deg(delta.angle())
	angle = fmod(angle + 360.0, 360.0)  # Normalizza tra 0–360
	return angle


# SISTEMA TOUCH DELL'AMICO ADATTATO - INIZIO
func swipe():
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("press"):
		if not swiping:
			swiping = true
			startSwipe = get_viewport().get_mouse_position()

	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("press"):
		if swiping:
			curSwipe = get_viewport().get_mouse_position()
			if startSwipe.distance_to(curSwipe) >= swipeLength:
				var angle = get_swipe_angle(startSwipe, curSwipe)
				
				if angle >= 25 and angle <= 65:  # ↗️
					if is_on_floor():
						velocity.y = JUMP_VELOCITY
						$JumpAudio.play()
					if target_lane > 0:
						var proposed_lane = target_lane - 1
						if can_move_to_lane(proposed_lane):
							target_lane = proposed_lane

				elif angle >= 115 and angle <= 155:  # ↖️
					if is_on_floor():
						velocity.y = JUMP_VELOCITY
						$JumpAudio.play()
					if target_lane < LANES.size() - 1:
						var proposed_lane = target_lane + 1
						if can_move_to_lane(proposed_lane):
							target_lane = proposed_lane

				elif angle >= 295 and angle <= 335:  # ↘️
					if not is_on_floor():
						velocity.y = -JUMP_VELOCITY * 1.2
					if target_lane > 0:
						var proposed_lane = target_lane - 1
						if can_move_to_lane(proposed_lane):
							target_lane = proposed_lane
							
				elif angle >= 205 and angle <= 245:  # ↙️
					if not is_on_floor():
						velocity.y = -JUMP_VELOCITY * 1.2
					if target_lane < LANES.size() - 1:
						var proposed_lane = target_lane + 1
						if can_move_to_lane(proposed_lane):
							target_lane = proposed_lane
							
				elif abs(startSwipe.y - curSwipe.y) < threshold:
					swipeDir = 1 if startSwipe.x < curSwipe.x else -1
					
				elif abs(startSwipe.x - curSwipe.x) < threshold:
					if startSwipe.y > curSwipe.y and is_on_floor():
						velocity.y = JUMP_VELOCITY
						$JumpAudio.play()
					elif startSwipe.y < curSwipe.y and not is_on_floor():
						velocity.y = -JUMP_VELOCITY * 1.2

				swiping = false
	else:
		swiping = false

# SISTEMA TOUCH DELL'AMICO ADATTATO - FINE

# Movimento fisico
func _physics_process(delta: float) -> void:
	# Aumenti progressivi
	GRAVITY += ACCELERATION * delta
	speed += ACCELERATION / 2 * delta
	JUMP_VELOCITY += ACCELERATION / 7 * delta
	
	# SISTEMA TOUCH DELL'AMICO - CHIAMATA
	swipe()
	
	if ok:
		# CONTROLLI TOUCH - Gestione cambio corsia (CORRETTO)
		if swipeDir == -1:  # Swipe a destra
			if target_lane < LANES.size() - 1:
				var proposed_lane = target_lane + 1
				if can_move_to_lane(proposed_lane):
					target_lane = proposed_lane
			swipeDir = 0
		elif swipeDir == 1:  # Swipe a sinistra
			if target_lane > 0:
				var proposed_lane = target_lane - 1
				if can_move_to_lane(proposed_lane):
					target_lane = proposed_lane
			swipeDir = 0
		
		# Cambio corsia a sinistra (tastiera)
		if Input.is_action_just_pressed("move_left") and target_lane < LANES.size() - 1:
			var proposed_lane = target_lane + 1
			if can_move_to_lane(proposed_lane):
				target_lane = proposed_lane

		# Cambio corsia a destra (tastiera)
		if Input.is_action_just_pressed("move_right") and target_lane > 0:
			var proposed_lane = target_lane - 1
			if can_move_to_lane(proposed_lane):
				target_lane = proposed_lane

		# Movimento laterale verso corsia target
		var current_x: float = global_transform.origin.x
		global_transform.origin.x = move_toward(current_x, LANES[target_lane], speed * delta)

		# Gravità e salto
		if not is_on_floor():
			velocity.y -= GRAVITY * delta
			if Input.is_key_pressed(KEY_C) and has_jumped:
				has_jumped = false
		else:
			# NON resettare velocity.y se è già stata impostata per il salto
			if velocity.y <= 0:
				velocity.y = 0
			has_jumped = true

		# Salto (tastiera)
		if is_on_floor() and (Input.is_action_pressed("jump")):
			velocity.y = JUMP_VELOCITY
			$JumpAudio.play()

		# Salto verso il basso (tastiera)
		if not is_on_floor() and (Input.is_action_pressed("down") or Input.is_action_pressed("ui_down")):
			velocity.y = -JUMP_VELOCITY * 1.2

	# Movimento finale
	move_and_slide()

	# Ritorno a Z target
	if target_z > position.z:
		position.z = move_toward(position.z, target_z, z_recovery_speed * delta)
		if abs(position.z - target_z) < 0.01:
			position.z = target_z

	# Impedisce di tornare indietro nel tempo
	if position.z > max_z_reached:
		max_z_reached = position.z
	elif position.z < max_z_reached:
		position.z = max_z_reached

	# Animazione sempre in corsa
	$kid/AnimationPlayer.play("CharacterArmature|Run")
	$chicken2/AnimationPlayer.play("run")
	

# Collisioni
func _on_area_3d_body_entered(body: Node3D) -> void:

	var collision_body := body as CollisionObject3D
	var body_layer: int = collision_body.collision_layer

	if body_layer & (1 << 1):  # Layer 2: ostacoli (fanno perdere vita)
		food_entered.emit(body)
		if $DamageAudio.playing:
			$DamageAudio.stop()
		if not $DamageAudio.playing:
			$DamageAudio.play()
		hit.emit()

	elif body_layer & (1 << 3):  # Layer 4: cibo (recupera vita)
		food_entered.emit(body)
		if $LifeAudio.playing:
			$LifeAudio.stop()
		if not $LifeAudio.playing: # Ferma il suono se stava già suonando
			$LifeAudio.play()   # E lo fa ripartire subito
		food.emit()


func _on_timer_timeout() -> void:
	ok=true
