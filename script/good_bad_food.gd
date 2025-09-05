extends Label

func _ready():
	update_food_counts()

func update_food_counts():
	var collected_food = GameStats.collected_food
	var bad_foods := [
		"birra", "pane", "burrito", "cereali", "cheeseburger", "biscotti",
		"cornetto", "ciambella", "hotdog", "pancake", "pizza",
		"spaghetti", "taco"
	]

	var total_good := 0
	var total_bad := 0
		
	for food_name in collected_food.keys():
		var quantity :int = collected_food[food_name]
		if bad_foods.has(food_name):
			total_bad += quantity
		else:
			total_good += quantity
	
	text = "Nice food: %d\nBad food: %d" % [total_good, total_bad]
