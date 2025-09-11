extends Node3D

@export var food_name: String
@onready var food : Node3D = $"."
@onready var sprite: Sprite3D = food.get_node("Sprite3D")
@onready var omni : OmniLight3D = food.get_node("StaticBody3D/OmniLight3D")
@onready var omni2 : OmniLight3D = food.get_node("StaticBody3D2/OmniLight3D")

var speed: float = 4
var rotation_speed: float = 1.5

func _ready():
	add_to_group("food")
	
	#controlla difficoltà di gioco
	match GameState.diff:
		1:
			if omni: omni.visible = true
			if omni2: omni2.visible = true
			if sprite: sprite.visible = true
		2:
			if omni: omni.visible=false
			if omni2: omni2.visible = false
			if sprite: sprite.visible = true
		3:
			if omni: omni.visible=false
			if omni2: omni2.visible = false
			if sprite: sprite.visible = false
		
	# Se food_name è vuoto, usa il nome del file .tscn
	if food_name == "":
		if get_scene_file_path() != "": 
			food_name = get_scene_file_path().get_file().get_basename()  # Ottieni il nome del file senza l'estensione
		else:
			food_name = name  # In alternativa, usa il nome del nodo se non riesci a recuperare il file

func _physics_process(delta: float) -> void:
	position.z -= speed * delta
	rotation.y += rotation_speed * delta
	if position.z < -5:
		deactivate()

func deactivate():
	visible = false
	position = Vector3(0, -1000, 0) # o fuori dallo schermo

func _on_area_3d_body_entered(body: Node3D) -> void:
	# Quando il cibo viene raccolto, registralo usando il nome dal file .tscn
	GameStats.register_food(food_name)
	await get_tree().create_timer(0.02).timeout
	deactivate()
