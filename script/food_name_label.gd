extends Button

@export var food_name: String
@onready var btn = $"."  # Questo è il nodo stesso, perché estendi Button
@onready var food_scene = $"../.."  # Nodo principale a due livelli sopra

func _ready() -> void:
	food_name = food_scene.name
	btn.text = food_name
