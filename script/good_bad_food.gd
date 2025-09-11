extends Label

# Dizionario per accesso O(1)
const BAD_FOODS: Dictionary = {
	"birra": true, "pane": true, "burrito": true, "cereali": true,
	"cheeseburger": true, "biscotti": true, "cornetto": true,
	"ciambella": true, "hotdog": true, "pancake": true, "pizza": true,
	"spaghetti": true, "taco": true
}

func _ready():
	update_food_counts()

func update_food_counts():
	var collected_food: Dictionary = GameStats.collected_food
	
	var total_good := 0
	var total_bad := 0
	
	for food_name in collected_food.keys():
		var quantity: int = collected_food[food_name]
		if BAD_FOODS.has(food_name):  # O(1) lookup
			total_bad += quantity
		else:
			total_good += quantity
	
	text = "Nice food: %d\nBad food: %d" % [total_good, total_bad]
