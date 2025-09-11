extends Node

# Variabili per le scene di ostacoli e cibi
const OBSTACLES_COLAZIONE: Array[PackedScene] = [
	preload("res://scene/food/pane.tscn"),
	preload("res://scene/food/pancake.tscn"),
	preload("res://scene/food/cornetto.tscn"),
	preload("res://scene/food/ciambella.tscn"),
	preload("res://scene/food/cereali.tscn"),
	preload("res://scene/food/biscotti.tscn"),
]

const OBSTACLES_PRANZO: Array[PackedScene] = [
	preload("res://scene/food/pizza.tscn"),
	preload("res://scene/food/spaghetti.tscn"),
	preload("res://scene/food/pane.tscn"),
	preload("res://scene/food/taco.tscn"),
	preload("res://scene/food/burrito.tscn"),
]

const OBSTACLES_CENA: Array[PackedScene] = [
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

const ALIMENTI_COLAZIONE: Array[PackedScene] = [
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

const ALIMENTI_PRANZO: Array[PackedScene] = [
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

const ALIMENTI_CENA: Array[PackedScene] = [
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
# ==============================
# Dizionario statico con scale e posizioni per i cibi
# ==============================
const FOOD_PROPERTIES := {
	"mela": {"scale": Vector3(1.5, 1.5, 1.5), "y": 0.6},
	"bacon e uova": {"scale": Vector3(0.5, 0.5, 0.5), "y": 0.5},
	"banana": {"scale": Vector3(1, 1, 1), "y": 0.6},
	"avocado": {"scale": Vector3(1.2, 1.2, 1.2), "y": 0.5},
	"taco": {"scale": Vector3(1.2, 1.2, 1.2), "y": 0.5},
	"cornetto": {"scale": Vector3(2, 2, 2), "y": 0.6},
	"pane": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"ciambella": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"yogurt": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"burro": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"birra": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"cioccolata": {"scale": Vector3(3, 3, 3), "y": 0.8},
	"succo di mela": {"scale": Vector3(1.5, 1.5, 1.5), "y": 0.8},
	"latte": {"scale": Vector3(1.5, 1.5, 1.5), "y": 0.8},
	"pancake": {"scale": Vector3(2, 2, 2), "y": 0.5},
	"pollo": {"scale": Vector3(4, 4, 4), "y": 0.5},
	"cereali": {"scale": Vector3(4, 4, 4), "y": 1},
	"pesce": {"scale": Vector3(1.5, 1.5, 1.5), "y": 0.5},
	"pizza": {"scale": Vector3(2.2, 2.2, 2.2), "y": 0.7},
	"riso": {"scale": Vector3(4, 4, 4), "y": 1},
	"spaghetti": {"scale": Vector3(2, 2, 2), "y": 0.7},
	"carne": {"scale": Vector3(4, 4, 4), "y": 0.5},
	"pomodori": {"scale": Vector3(0.6, 0.6, 0.6), "y": 0.5},
	"lattuga": {"scale": Vector3(0.6, 0.6, 0.6), "y": 0.5},
	"sushi": {"scale": Vector3(0.6, 0.6, 0.6), "y": 0.5},
	"melanzana": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"formaggio": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.8},
	"tonno": {"scale": Vector3(1, 1, 1), "y": 0.7},
	"biscotti": {"scale": Vector3(1, 1, 1), "y": 0.7},
	"carota": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.5},
	"hotdog": {"scale": Vector3(2.5, 2.5, 2.5), "y": 0.5},
	"formaggioburger": {"scale": Vector3(0.7, 0.7, 0.7), "y": 0.7},
	"patatine": {"scale": Vector3(3.5, 3.5, 3.5), "y": 0.6},
	"burrito": {"scale": Vector3(0.8, 0.8, 0.8), "y": 0.5},
	"kiwi": {"scale": Vector3(0.3, 0.3, 0.3), "y": 0.5},
}

# ==============================
# Funzione ottimizzata
# ==============================
func match_food(food_instance: Node3D) -> void:
	if food_instance.food_name in FOOD_PROPERTIES:
		var props = FOOD_PROPERTIES[food_instance.food_name]
		food_instance.scale = props.scale
		food_instance.position.y = props.y
	else:
		# default
		food_instance.scale = Vector3.ONE
		food_instance.position.y = 0.35
		
const OBSTACLES := {
	GameState.lv.colazione: OBSTACLES_COLAZIONE,
	GameState.lv.pranzo: OBSTACLES_PRANZO,
	GameState.lv.cena: OBSTACLES_CENA
}

const ALIMENTI := {
	GameState.lv.colazione: ALIMENTI_COLAZIONE,
	GameState.lv.pranzo: ALIMENTI_PRANZO,
	GameState.lv.cena: ALIMENTI_CENA
}

func get_current_obstacle_list(level: int) -> Array:
	return OBSTACLES.get(level, [])

func get_current_food_list(level: int) -> Array:
	return ALIMENTI.get(level, [])
