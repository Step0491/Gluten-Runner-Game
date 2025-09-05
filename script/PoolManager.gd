extends Node

# Variabili per il pool
var obstacle_pool: Array = []
var food_pool: Array = []
var cache: Dictionary = {}

# Funzione per caricare le scene in cache
func load_cached(path: String) -> PackedScene:
	if cache.has(path):
		return cache[path]
	var scene = load(path)
	if scene:
		cache[path] = scene
	return scene

# Funzione per inizializzare il pool degli ostacoli
func init_obstacle_pool(obstacles: Array) -> void:
	for scene in obstacles:
		var inst = scene.instantiate()
		inst.visible = false
		inst.position = Vector3(0, -1000, 0)
		inst.name = inst.scene_file_path.get_file().get_basename()
		inst.food_name = inst.name  # Nome per gli ostacoli
		add_child(inst)
		obstacle_pool.append(inst)

# Funzione per inizializzare il pool dei cibi
func init_food_pool(foods: Array) -> void:
	for scene in foods:
		var inst = scene.instantiate()
		inst.visible = false
		inst.position = Vector3(0, -1000, 0)
		inst.name = inst.scene_file_path.get_file().get_basename()
		inst.food_name = inst.name
		add_child(inst)
		food_pool.append(inst)

# Funzione per ottenere un ostacolo dal pool
func get_pooled_obstacle(obstacles: Array) -> Node3D:
	for o in obstacle_pool:
		if is_instance_valid(o) and not o.visible:
			reset_entity(o)
			return o
	var scene: PackedScene = obstacles.pick_random()  # Usa l'array passato
	var inst = scene.instantiate()
	inst.name = inst.scene_file_path.get_file().get_basename()
	inst.food_name = inst.name
	add_child(inst)
	reset_entity(inst)
	obstacle_pool.append(inst)
	return inst


# Funzione per ottenere un cibo dal pool
func get_pooled_food(foods: Array) -> Node3D:  # Passa l'array degli alimenti come argomento
	for f in food_pool:
		if is_instance_valid(f) and not f.visible:
			reset_entity(f)
			return f
	var scene: PackedScene = foods.pick_random()  # Usa l'array passato
	var inst = scene.instantiate()
	inst.name = inst.scene_file_path.get_file().get_basename()
	inst.food_name = inst.name
	add_child(inst)
	reset_entity(inst)
	food_pool.append(inst)
	return inst

func reset_pools() -> void:
	for inst in food_pool:
		if is_instance_valid(inst):
			inst.queue_free()
	food_pool.clear()

	for inst in obstacle_pool:
		if is_instance_valid(inst):
			inst.queue_free()
	obstacle_pool.clear()

	cache.clear()


# Funzione per resettare un'entità
func reset_entity(e: Node3D):
	e.visible = true
	e.scale = Vector3.ONE
	e.rotation = Vector3.ZERO
	e.position = Vector3(0, -1000, 0)
	e.name = e.scene_file_path.get_file().get_basename() + "_" + str(randi())
	e.food_name = e.scene_file_path.get_file().get_basename()
	# Invoca una funzione per applicare parametri specifici
	FoodManager.match_food(e)
