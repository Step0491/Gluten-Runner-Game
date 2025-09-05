extends Node

# Variabili per le scene di ostacoli e cibi
var obstacles_colazione_scenes = [
	preload("res://scene/food/pane.tscn"),
	preload("res://scene/food/pancake.tscn"),
	preload("res://scene/food/cornetto.tscn"),
	preload("res://scene/food/ciambella.tscn"),
	preload("res://scene/food/cereali.tscn"),
	preload("res://scene/food/biscotti.tscn"),
]

var obstacles_pranzo_scenes = [
	preload("res://scene/food/pizza.tscn"),
	preload("res://scene/food/spaghetti.tscn"),
	preload("res://scene/food/pane.tscn"),
	preload("res://scene/food/taco.tscn"),
	preload("res://scene/food/burrito.tscn"),
]

var obstacles_cena_scenes = [
	preload("res://scene/food/hotdog.tscn"),
	preload("res://scene/food/cheeseburger.tscn"),
	preload("res://scene/food/pizza.tscn"),
	preload("res://scene/food/spaghetti.tscn"),
	preload("res://scene/food/taco.tscn"),
	preload("res://scene/food/burrito.tscn"),
	preload("res://scene/food/birra.tscn"),
	preload("res://scene/food/biscotti.tscn"),
	preload("res://scene/food/cereali.tscn"),
]

var alimenti_colazione_scenes = [
	preload("res://scene/food/mela.tscn"),
	preload("res://scene/food/succo di mela.tscn"),
	preload("res://scene/food/avocado.tscn"),
	preload("res://scene/food/bacon e uova.tscn"),
	preload("res://scene/food/banana.tscn"),
	preload("res://scene/food/cioccolata.tscn"),
	preload("res://scene/food/latte.tscn"),
	preload("res://scene/food/yogurt.tscn"),
	preload("res://scene/food/kiwi.tscn"),
	preload("res://scene/food/burro.tscn"),
]

var alimenti_pranzo_scenes = [
	preload("res://scene/food/riso.tscn"),
	preload("res://scene/food/pollo.tscn"),
	preload("res://scene/food/pesce.tscn"),
	preload("res://scene/food/carne.tscn"),
	preload("res://scene/food/lattuga.tscn"),
	preload("res://scene/food/melanzana.tscn"),
	preload("res://scene/food/pomodori.tscn"),
	preload("res://scene/food/carota.tscn"),
	preload("res://scene/food/mela.tscn"),
	preload("res://scene/food/formaggio.tscn"),
	preload("res://scene/food/sushi.tscn"),
	preload("res://scene/food/tonno.tscn"),
	preload("res://scene/food/kiwi.tscn"),
	preload("res://scene/food/burro.tscn"),
]

var alimenti_cena_scenes = [
	preload("res://scene/food/pollo.tscn"),
	preload("res://scene/food/pesce.tscn"),
	preload("res://scene/food/carne.tscn"),
	preload("res://scene/food/patatine.tscn"),
	preload("res://scene/food/sushi.tscn"),
	preload("res://scene/food/tonno.tscn"),
	preload("res://scene/food/riso.tscn"),
	preload("res://scene/food/pollo.tscn"),
	preload("res://scene/food/pesce.tscn"),
	preload("res://scene/food/melanzana.tscn"),
	preload("res://scene/food/mela.tscn"),
	preload("res://scene/food/pomodori.tscn"),
	preload("res://scene/food/kiwi.tscn"),
	preload("res://scene/food/burro.tscn"),
]

# Funzione per ottenere la lista di ostacoli in base al livello
func get_current_obstacle_list(level: int) -> Array:
	match level:
		GameState.lv.colazione:
			return obstacles_colazione_scenes
		GameState.lv.pranzo:
			return obstacles_pranzo_scenes
		GameState.lv.cena:
			return obstacles_cena_scenes
	return []

# Funzione per ottenere la lista dei cibi in base al livello
func get_current_food_list(level: int) -> Array:
	match level:
		GameState.lv.colazione:
			return alimenti_colazione_scenes
		GameState.lv.pranzo:
			return alimenti_pranzo_scenes
		GameState.lv.cena:
			return alimenti_cena_scenes
	return []

# Funzione per abbinare il cibo a una scala e una posizione
func match_food(food_instance: Node3D) -> void:
	match food_instance.food_name:
		"mela":
			food_instance.scale = Vector3(1.5, 1.5, 1.5)
			food_instance.position.y = 0.6
		"bacon e uova":
			food_instance.scale = Vector3(0.5, 0.5, 0.5)
			food_instance.position.y = 0.5
		"banana":
			food_instance.scale = Vector3.ONE
			food_instance.position.y = 0.6
		"avocado", "taco":
			food_instance.scale = Vector3(1.2, 1.2, 1.2)
			food_instance.position.y = 0.5
		"cornetto":
			food_instance.scale = Vector3(2, 2, 2)
			food_instance.position.y = 0.6
		"pane", "ciambella", "yogurt", "burro", "birra":
			food_instance.scale = Vector3(2.5, 2.5, 2.5)
			food_instance.position.y = 0.8
		"cioccolata":
			food_instance.scale = Vector3(3, 3, 3)
			food_instance.position.y = 0.8
		"succo di mela", "latte":
			food_instance.scale = Vector3(1.5, 1.5, 1.5)
			food_instance.position.y = 0.8
		"pancake":
			food_instance.scale = Vector3(2, 2, 2)
			food_instance.position.y = 0.5
		"pollo":
			food_instance.scale = Vector3(4, 4, 4)
			food_instance.position.y = 0.5
		"cereali":
			food_instance.scale = Vector3(4, 4, 4)
			food_instance.position.y = 1
		"pesce":
			food_instance.scale = Vector3(1.5, 1.5, 1.5)
			food_instance.position.y = 0.5
		"pizza":
			food_instance.scale = Vector3(2.2, 2.2, 2.2)
			food_instance.position.y = 0.7
		"riso":
			food_instance.scale = Vector3(4, 4, 4)
			food_instance.position.y = 1
		"spaghetti":
			food_instance.scale = Vector3(2, 2, 2)
			food_instance.position.y = 0.7
		"carne":
			food_instance.scale = Vector3(4, 4, 4)
			food_instance.position.y = 0.5
		"pomodori", "lattuga", "sushi":
			food_instance.scale = Vector3(0.6, 0.6, 0.6)
			food_instance.position.y = 0.5
		"melanzana", "formaggio":
			food_instance.scale = Vector3(2.5, 2.5, 2.5)
			food_instance.position.y = 0.8
		"tonno", "biscotti":
			food_instance.scale = Vector3(1, 1, 1)
			food_instance.position.y = 0.7
		"carota", "hotdog":
			food_instance.scale = Vector3(2.5, 2.5, 2.5)
			food_instance.position.y = 0.5
		"formaggioburger":
			food_instance.scale = Vector3(0.7, 0.7, 0.7)
			food_instance.position.y = 0.7
		"patatine":
			food_instance.scale = Vector3(3.5, 3.5, 3.5)
			food_instance.position.y = 0.6
		"burrito":
			food_instance.scale = Vector3(0.8, 0.8, 0.8)
			food_instance.position.y = 0.5
		"kiwi":
			food_instance.scale = Vector3(0.3, 0.3, 0.3)
			food_instance.position.y = 0.5
		_:
			food_instance.scale = Vector3.ONE
			food_instance.position.y = 0.35
