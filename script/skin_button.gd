extends Button

# Usa un percorso assoluto dalla scena principale
@onready var player = get_tree().get_current_scene().get_node("Giocatore")

@onready var human_model = player.get_node("kid")
@onready var chicken_model = player.get_node("chicken2")

@onready var human_collision = player.get_node("CollisionShapehuman")
@onready var chicken_collision = player.get_node("CollisionShapepollo")

@onready var human_area_shape = player.get_node("Area3D/CollisionShape3D2")
@onready var chicken_area_shape = player.get_node("Area3D/CollisionShapepollo2")
@onready var progress_bar = player.get_node("Sprite3D")
@onready var original_bar_position = progress_bar.position

var is_human := true

func _ready():
	connect("pressed", Callable(self, "_on_skin_button_pressed"))

func _on_skin_button_pressed():
	is_human = !is_human

	human_model.visible = is_human
	chicken_model.visible = !is_human

	human_collision.visible = is_human
	chicken_collision.visible = !is_human

	human_area_shape.visible = is_human
	chicken_area_shape.visible = !is_human
	
		# Sposta la barra della vita in base al personaggio
	if is_human:
		progress_bar.position = original_bar_position  # ritorna alla posizione salvata
	else:
		var lowered = original_bar_position
		lowered.y -= 3.2  # abbassa la barra per il pollo
		progress_bar.position = lowered
