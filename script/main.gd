extends Node

# ---------------------------
# Nodi audio (onready)
# ---------------------------
@onready var music_game = $MusicGame
@onready var music_intro = $music_intro

# ---------------------------
# COSTANTI: preload scene di effetti (resolte staticamente)
# ---------------------------
const EXPLOSION_RED_SCENE   : PackedScene = preload("res://scene/explosionred.tscn")
const EXPLOSION_GREEN_SCENE : PackedScene = preload("res://scene/explosiongreen.tscn")
const EXPLOSION_BLU_SCENE   : PackedScene = preload("res://scene/explosionblu.tscn")

# ---------------------------
# other onready / exported
# ---------------------------
@onready var timer         = $"Timer"
@onready var intro_music   = $music_intro
@onready var game_music    = $MusicGame
@onready var n_food        = $n_food

@export var max_score: int = 0
@export var num_partite: int = 0

# ---------------------------
# Variabili di stato
# ---------------------------
var cache: Dictionary = {}
var print_timer: int = 0
var acceleration_obst: float = 0.2
var speed_obst: float = 4
var timer_decrease: float = 0.013
var obst_damage: int = 50
var life_point: int = 10

enum lv { colazione, pranzo, cena }

const MIN_WAIT_TIME := 0.4
var total_elapsed_time: float = 0.0
var count: int = 0
var collected_food_names: Array = []
var count_food: int = 0

# ---------------------------
# POOL (cache helper)
# ---------------------------
func load_cached(path: String) -> PackedScene:
	# restituisce PackedScene dalla cache o la carica e salva nella cache
	if cache.has(path):
		return cache[path] as PackedScene
	var res = ResourceLoader.load(path)
	if res and res is PackedScene:
		cache[path] = res
		return res
	# fallback: tenta load come ultima risorsa
	var scene = load(path)
	if scene and scene is PackedScene:
		cache[path] = scene
		return scene
	return null

func _ready():
	# Inizializza i pool all'avvio (stesse chiamate originali)
	PoolManager.init_obstacle_pool(FoodManager.get_current_obstacle_list(GameState.lv_corrente))
	PoolManager.init_food_pool(FoodManager.get_current_food_list(GameState.lv_corrente))

	# Configurazione audio
	if OS.get_name() == "Android":
		await get_tree().create_timer(0.1).timeout
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Musics"), 0.0)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SfxVol"), 0.0)

	# UI iniziale (nessuna modifica alla grafica / animazioni)
	$Canvasblack/BlackBackground.modulate.a = 1.0
	$Canvasblack.visible = true
	$AnimationPlayer.play("dark_main")
	$TutorialOverlay.visible = false
	$TutorialOverlay/slide0.visible = false 
	$TutorialOverlay/slide1.visible = false
	$volume_button/volume_btn.update_button_style()
	$volume_button/volume_btn.visible = true
	$volume_button/ColorRect.visible = false
	$info/ColorRect.visible = false
	$skin_button/ColorRect.visible = false
	$WorldController.update_lighting()
	n_food.text = "Collected food: 0"

	intro_music.play()
	await intro_music.finished
	await $AnimationPlayer.animation_finished
	timer.stop()
	await get_tree().create_timer(0.1).timeout
	timer.start()
	music_game.play()

# Funzione per ottenere un ostacolo dal pool
func get_pooled_obstacle(obstacles: Array) -> Node3D:
	return PoolManager.get_pooled_obstacle(obstacles)

# Funzione per ottenere un cibo dal pool
func get_pooled_food(foods: Array) -> Node3D:
	return PoolManager.get_pooled_food(foods)

func return_pooled_entity(e: Node3D) -> void:
	if not is_instance_valid(e):
		return
	e.visible = false
	e.position.x = 0
	e.position.z = -1000

# ---------------------------
# Spawning
# ---------------------------

func spawn_random_objects(object_list: Array, count: int, used_positions: Array, is_obstacle: bool) -> void:
	if object_list.is_empty():
		return

	var x_positions = [-1.4, 0.0, 1.4]
	x_positions.shuffle()

	for i in range(count):
		var instance: Node3D
		if is_obstacle:
			instance = get_pooled_obstacle(FoodManager.get_current_obstacle_list(GameState.lv_corrente))
		else:
			instance = get_pooled_food(FoodManager.get_current_food_list(GameState.lv_corrente))

		# Posizionamento casuale
		var z = randf_range(37, 46)
		var x = find_free_x(used_positions, z)
		if x == null:
			continue

		var final_y = instance.position.y  # Mantiene Y da match_food
		instance.position = Vector3(x, final_y, z)
		instance.rotation.y = deg_to_rad(randf_range(-180, 180))
		instance.speed = speed_obst

		used_positions.append(Vector2(x, z))

func _on_timer_timeout() -> void:
	total_elapsed_time += timer.wait_time
	var game_stage : int = clamp(int(total_elapsed_time / 15), 0, 10)

	if count > 2:
		var new_wait_time : float = 1.5 - (game_stage * 0.1)
		timer.wait_time = clamp(new_wait_time, MIN_WAIT_TIME, 1.5)
		count = 0
	count += 1

	# Ottieni le liste in base al livello
	var obstacle_list: Array = FoodManager.get_current_obstacle_list(GameState.lv_corrente)
	var food_list: Array = FoodManager.get_current_food_list(GameState.lv_corrente)

	# Calcola il numero di ostacoli e cibi da spawnare in base al livello
	var obstacle_count: int
	match game_stage:
		0:
			obstacle_count = 0
		1, 2, 3:
			obstacle_count = randi_range(0, 1)
		4, 5, 6:
			obstacle_count = randi_range(1, 2)
		_:
			obstacle_count = randi_range(2, 3)

	var food_count: int
	match game_stage:
		0, 1:
			food_count = 1
		2, 3:
			food_count = randi_range(1, 2)
		4, 5, 6:
			food_count = randi_range(2, 3)
		_:
			food_count = 3

	# Posizioni usate (x, z)
	var used_positions: Array = []

	# SPAWN OSTACOLI
	spawn_random_objects(obstacle_list, obstacle_count, used_positions, true)

	await get_tree().create_timer(timer.wait_time / 2.0).timeout

	# SPAWN CIBO
	spawn_random_objects(food_list, food_count, used_positions, false)

# Funzione per ottenere la lista degli ostacoli in base al livello corrente
func get_current_obstacle_list() -> Array:
	return PoolManager.get_current_obstacle_list()

# Funzione per ottenere la lista dei cibi in base al livello corrente
func get_current_food_list() -> Array:
	return PoolManager.get_current_food_list()

func find_free_x(used_positions: Array, z: float) -> float:
	var x_opts = [-1.4, 0.0, 1.4]
	x_opts.shuffle()
	for x in x_opts:
		var conflict := false
		for pos in used_positions:
			if abs(pos.x - x) < 0.1 and abs(pos.y - z) < 1.5:
				conflict = true
				break
		if not conflict:
			return x
	# se non trova pos libera, ritorna null (gestito dai caller)
	return 0.0

# Gestione eventi di Game Over
func game_over() -> void:
	timer.stop()
	var expl = EXPLOSION_RED_SCENE.instantiate()
	expl.position = $Giocatore.position
	add_child(expl)
	expl.emitting = true

	if not $DamageAudio.playing:
		$DamageAudio.play()
	await get_tree().create_timer(0.1).timeout
	$Giocatore.queue_free()
	await get_tree().create_timer(0.5).timeout
	get_tree().paused = false

	$AnimationPlayer.play("fade_in_gameover")
	$Canvasblack/GameOver.visible = true
	await get_tree().create_timer(1).timeout
	if music_game.playing:
		music_game.stop()
	if not $GameoverSfx.playing:
		$GameoverSfx.play()
	await get_tree().create_timer(2).timeout
	$Canvasblack/GameOver.visible = false
	GameStats.compute_estimated_quality_from_bad_list()
	PoolManager.clear_active_entities()  # 👈 ripulisce subito ostacoli/cibo
	# Aggiorna UserStats
	UserStats.aggiorna_statistiche(int($scoree.text), int(GameStats.Good), int(GameStats.Bad), GameStats.collected_food)

	# Salva subito per non perdere i dati
	UserStats.salva_statistiche()
	
	get_tree().change_scene_to_file("res://scene/summary_screen.tscn")

# Gestione pulsante pausa
func _on_button_pressed() -> void:
	if not get_tree().paused:
		get_tree().paused = true
		$menu_pausa/PauseMenu.visible=true
		$tasto_pausa/AnimationPlayer.play("visible")
		$menu_pausa/PauseMenu/AnimationPlayer.play("blur")
		$volume_button/ColorRect.visible = true
		$info/ColorRect.visible = true
		$skin_button/ColorRect.visible = true
		$volume_button/AnimationPlayer.play("blur")
		$info/AnimationPlayer.play("blur")
		$skin_button/AnimationPlayer.play("blur")

# Gestione pulsante info
func _on_info_btn_pressed() -> void:
	if not get_tree().paused:
		get_tree().paused = true
		
		#slide 0 pc
		$TutorialOverlay.visible = true
		$TutorialOverlay/slide0.visible = true
		$TutorialOverlay/AnimationTree.play("visible")
		await get_tree().create_timer(3).timeout
		$TutorialOverlay/AnimationTree.play_backwards("visible")
		await $TutorialOverlay/AnimationTree.animation_finished
		$TutorialOverlay/slide0.visible = false

		##slide 0 telefoni
		#$TutorialOverlay.visible = true
		#$TutorialOverlay/slide05.visible = true
		#$TutorialOverlay/AnimationTree.play("visible")
		#await get_tree().create_timer(3).timeout
		#$TutorialOverlay/AnimationTree.play_backwards("visible")
		#await $TutorialOverlay/AnimationTree.animation_finished
		#$TutorialOverlay/slide05.visible = false


		# slide 1
		$TutorialOverlay/slide1.visible = true
		$TutorialOverlay/AnimationTree.play("visible")
		await get_tree().create_timer(2).timeout
		$TutorialOverlay/AnimationTree.play_backwards("visible")
		await $TutorialOverlay/AnimationTree.animation_finished
		$TutorialOverlay/slide1.visible = false
		
		$TutorialOverlay.visible = false
		get_tree().paused = false
	
func _on_giocatore_hit() -> void:
	await get_tree().process_frame
	$Giocatore.take_damage(obst_damage)
	if $Giocatore.health > 0:
		var expl = EXPLOSION_BLU_SCENE.instantiate()
		expl.position = $Giocatore.position
		expl.position.z += 0.2
		add_child(expl)
		expl.emitting = true

func _on_giocatore_food() -> void:
	$Giocatore.gain_life(life_point)
	var expl = EXPLOSION_GREEN_SCENE.instantiate()
	expl.position = $Giocatore.position
	expl.position.z += 0.2
	add_child(expl)
	expl.emitting = true
	
func _on_giocatore_dead() -> void:
	var expl = EXPLOSION_RED_SCENE.instantiate()
	expl.position = $Giocatore.position
	add_child(expl)
	expl.emitting = true
	await get_tree().create_timer(2).timeout

func _on_giocatore_food_entered(body: Node3D) -> void:
	collected_food_names.append(body.name)
	count_food = count_food + 1
	n_food.text = "Collected food: %d" % count_food
	
func _physics_process(delta: float) -> void:
	speed_obst += acceleration_obst * delta
	# velocità e accelerazione ostacoli autogestita dal main

func _start_music_delayed() -> void:
	await get_tree().create_timer(6.5).timeout
	music_game.play()
