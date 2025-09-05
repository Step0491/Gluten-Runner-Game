extends Node

var collected_food : Dictionary = {}   # { "apple": 3, "pizza": 1, … }
var estimated_quality_percent : float = 0.0  # Range: 0.0–100.0
var Good: int
var Bad: int
var Tot: int

func reset():
	collected_food.clear()
	estimated_quality_percent = 0.0

func register_food(food_name: String):
	if not food_name.begins_with("@Node3D"):  # Evita print, ma mantiene controllo logico
		collected_food[food_name] = collected_food.get(food_name, 0) + 1

func food_count() -> int:
	return collected_food.size()

# ✅ Calcola la % di cibi buoni usando una lista di nomi noti come "cattivi"
func compute_estimated_quality_from_bad_list() -> void:
	var total :int = 0
	var good :int = 0

	var bad_foods := [
		"birra", "pane", "burrito", "cereali", "cheeseburger", "biscotti",
		"cornetto", "ciambella", "hotdog", "pancake", "patatine", "pizza",
		"spaghetti"
	]

	for name in collected_food.keys():
		var quantity :int = collected_food[name]
		total += quantity
		if not bad_foods.has(name):
			good += quantity

	if total == 0:
		estimated_quality_percent = 0.0
	else:
		estimated_quality_percent = float(good) / total * 100.0
		
	Bad = total - good
	Tot = total
	Good = good
