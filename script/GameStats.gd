extends Node

var collected_food: Dictionary = {}   # { "apple": 3, "pizza": 1, … }
var estimated_quality_percent: float = 0.0  # Range: 0.0–100.0
var Good: int
var Bad: int
var Tot: int

# ⚡ Lista cattivi trasformata in Set per lookup O(1)
const BAD_FOODS := {
	"birra": true, "pane": true, "burrito": true, "cereali": true,
	"cheeseburger": true, "biscotti": true, "cornetto": true, "ciambella": true,
	"hotdog": true, "pancake": true, "patatine": true, "pizza": true, "spaghetti": true
}

func reset() -> void:
	collected_food.clear()
	estimated_quality_percent = 0.0
	Good = 0
	Bad = 0
	Tot = 0

func register_food(food_name: String) -> void:
	if not food_name.begins_with("@Node3D"):
		collected_food[food_name] = collected_food.get(food_name, 0) + 1

func food_count() -> int:
	return collected_food.size()

# ✅ Calcola % di cibi buoni in maniera ottimizzata
func compute_estimated_quality_from_bad_list() -> void:
	Good = 0
	Bad = 0
	Tot = 0

	for name in collected_food:
		var quantity: int = collected_food[name]
		Tot += quantity

		if BAD_FOODS.has(name):
			Bad += quantity
		else:
			Good += quantity

	estimated_quality_percent = (float(Good) / Tot * 100.0) if Tot > 0 else 0.0
