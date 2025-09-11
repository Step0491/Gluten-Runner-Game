extends CharacterBody3D

# ====================
# COSTANTI
# ====================
const LANES: Array = [-1.4, 0, 1.4]
const ACCELERATION: float = 0.4
const SWIPE_LENGTH: float = 15
const SWIPE_THRESHOLD: float = 15
const LONG_SWIPE_FACTOR: float = 6 

# ====================
# VARIABILI FISICHE
# ====================
var GRAVITY: float = 28.0
var speed: float = 8.0
var JUMP_VELOCITY: float = 9.0

var starting_point: Vector3 = Vector3.ZERO
var current_lane: int = 1
var target_lane: int = 1

var max_health: int = 100
@export var health: int = 100
var is_dead: bool = false

var target_z: float = 0.0
var z_recovery_speed: float = 10.0
var max_z_reached: float = 0.0
var has_jumped: bool = true
var ok: bool = false

# ====================
# SISTEMA TOUCH
# ====================
var swiping: bool = false
var start_swipe: Vector2
var cur_swipe: Vector2
var swipe_dir: int = 0

# ====================
# SEGNALI
# ====================
signal hit
signal food
signal food_entered
signal dead

# ====================
# INIZIALIZZAZIONE
# ====================
func _ready() -> void:
	starting_point = global_transform.origin
	target_z = starting_point.z
	max_z_reached = starting_point.z
	add_to_group("player")

# ====================
# SALUTE
# ====================
func die() -> void:
	if is_dead:
		return
	is_dead = true
	dead.emit()
	$SubViewport/ProgressBar.hide()
	get_parent().game_over()

func update_health_bar() -> void:
	$SubViewport/ProgressBar.value = health

func take_damage(damage: int) -> void:
	if is_dead:
		return
	health = clamp(health - damage, 0, max_health)
	update_health_bar()
	if health == 0:
		die()

func gain_life(point: int) -> void:
	if is_dead or health >= max_health:
		return
	health = clamp(health + point, 0, max_health)
	update_health_bar()

# ====================
# UTILITY
# ====================
func can_move_to_lane(lane_index: int) -> bool:
	if lane_index < 0 or lane_index >= LANES.size():
		return false
	var from_pos = global_transform.origin
	var to_pos = Vector3(LANES[lane_index], from_pos.y, from_pos.z)
	var space_state = get_world_3d().direct_space_state
	var ray_params = PhysicsRayQueryParameters3D.create(from_pos, to_pos)
	ray_params.collision_mask = 0b100  # layer 3
	ray_params.exclude = [self]
	return space_state.intersect_ray(ray_params).is_empty()

func get_swipe_angle(start: Vector2, end: Vector2) -> float:
	var delta = end - start
	delta.y *= -1
	return fmod(rad_to_deg(delta.angle()) + 360.0, 360.0)

func perform_jump() -> void:
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
		$JumpAudio.play()

# ====================
# SISTEMA SWIPE MODULARE
# ====================
var SWIPE_ACTIONS = [
	# Angolo min, angolo max, salto?, corsia offset
	{ "min": 25, "max": 65, "jump": true,  "lane_offset": -1 },
	{ "min": 115, "max": 155, "jump": true, "lane_offset": 1 },
	{ "min": 295, "max": 335, "jump": false, "lane_offset": -1 },
	{ "min": 205, "max": 245, "jump": false, "lane_offset": 1 }
]

func swipe():
	var input_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("press"):
		swiping = true
		start_swipe = input_pos
	
	if swiping and (Input.is_action_pressed("ui_accept") or Input.is_action_pressed("press")):
		cur_swipe = input_pos
		var swipe_distance = start_swipe.distance_to(cur_swipe)
		if swipe_distance >= SWIPE_LENGTH:
			var angle = get_swipe_angle(start_swipe, cur_swipe)
			handle_swipe(angle, swipe_distance)
			swiping = false
	elif not Input.is_action_pressed("ui_accept") and not Input.is_action_pressed("press"):
		swiping = false

# ====================
# UTILITY AGGIORNATA
# ====================
func change_lane(new_lane: int) -> void:
	# Clamp tra 0 e 2
	new_lane = clamp(new_lane, 0, LANES.size() - 1)
	if new_lane != target_lane and can_move_to_lane(new_lane):
		target_lane = new_lane

# ====================
# SWIPE AGGIORNATO
# ====================
func handle_swipe(angle: float, swipe_distance: float) -> void:
	var dx: float = cur_swipe.x - start_swipe.x
	var dy: float = cur_swipe.y - start_swipe.y
	var long_swipe: bool = swipe_distance >= SWIPE_LENGTH * LONG_SWIPE_FACTOR

	# ------------------------
	# Swipe orizzontale lungo
	# ------------------------
	if long_swipe and abs(dx) > abs(dy):
		var swipe_dir: int = -1 if dx > 0 else 1
		change_lane(clamp(current_lane + swipe_dir * 2, 0, LANES.size() - 1))
		return

	# ------------------------
	# Swipe corto orizzontale
	# ------------------------
	if abs(dy) < SWIPE_THRESHOLD and abs(dx) >= SWIPE_THRESHOLD:
		var swipe_dir: int = -1 if dx > 0 else 1
		change_lane(clamp(current_lane + swipe_dir, 0, LANES.size() - 1))
		return

	# ------------------------
	# Swipe verticale corto
	# ------------------------
	if abs(dx) < SWIPE_THRESHOLD and abs(dy) >= SWIPE_THRESHOLD:
		if dy < 0 and is_on_floor():
			perform_jump()
		elif dy > 0 and not is_on_floor():
			velocity.y = -JUMP_VELOCITY * 1.2
		return

	# ------------------------
	# Swipe diagonali modulare (angolo)
	# ------------------------
	for action in SWIPE_ACTIONS:
		if angle >= action.min and angle <= action.max:
			if action.jump:
				perform_jump()
			var lane_offset = action.lane_offset
			change_lane(clamp(current_lane + lane_offset, 0, LANES.size() - 1))
			return


# ====================
# PHYSICS PROCESS AGGIORNATO
# ====================
func _physics_process(delta: float) -> void:
	# Incrementi progressivi
	GRAVITY += ACCELERATION * delta
	speed += ACCELERATION / 2 * delta
	JUMP_VELOCITY += ACCELERATION / 7 * delta

	if ok:
		# Input touch
		swipe()

		# Movimento tastiera
		if Input.is_action_just_pressed("move_left"):
			change_lane(current_lane + 1)
		elif Input.is_action_just_pressed("move_right"):
			change_lane(current_lane - 1)

		# Movimento verso target_lane
		global_transform.origin.x = move_toward(global_transform.origin.x, LANES[target_lane], speed * delta)

		# Aggiorna current_lane quando raggiunta
		if is_equal_approx(global_transform.origin.x, LANES[target_lane]):
			current_lane = target_lane

		# Gravità e salto
		if not is_on_floor():
			velocity.y -= GRAVITY * delta
			has_jumped = false
		else:
			if velocity.y <= 0:
				velocity.y = 0
			has_jumped = true
			if Input.is_action_just_pressed("jump"):
				perform_jump()

		# Salto verso il basso
		if not is_on_floor() and (Input.is_action_pressed("down") or Input.is_action_pressed("ui_down")):
			velocity.y = -JUMP_VELOCITY * 1.2

	move_and_slide()

	# Ritorno a Z target
	position.z = move_toward(position.z, max(target_z, max_z_reached), z_recovery_speed * delta)
	max_z_reached = max(position.z, max_z_reached)

	# Animazioni
	$kid/AnimationPlayer.play("CharacterArmature|Run")
	$chicken2/AnimationPlayer.play("run")

# ====================
# COLLISIONI
# ====================
func _on_area_3d_body_entered(body: Node3D) -> void:
	var collision_body := body as CollisionObject3D
	var body_layer: int = collision_body.collision_layer

	if body_layer & (1 << 1):  # Ostacoli
		food_entered.emit(body)
		$DamageAudio.play()
		hit.emit()
		print("giocatore collide ostacolo")
	elif body_layer & (1 << 3):  # Cibo
		food_entered.emit(body)
		$LifeAudio.play()
		food.emit()
		print("giocatore collide cibo")
	
func _on_timer_timeout() -> void:
	ok = true
