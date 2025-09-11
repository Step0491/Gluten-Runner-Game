extends Button

# ---------------------------
# Costanti statiche
# ---------------------------
const CHICKEN_BAR_OFFSET_Y: float = 3.2

# ---------------------------
# Nodi onready con tipo esplicito
# ---------------------------
@onready var player: Node3D = get_tree().get_current_scene().get_node("Giocatore")
@onready var human_model: Node3D = player.get_node("kid")
@onready var chicken_model: Node3D = player.get_node("chicken2")

@onready var human_collision: CollisionShape3D = player.get_node("CollisionShapehuman")
@onready var chicken_collision: CollisionShape3D = player.get_node("CollisionShapepollo")

@onready var human_area_shape: CollisionShape3D = player.get_node("Area3D/CollisionShape3D2")
@onready var chicken_area_shape: CollisionShape3D = player.get_node("Area3D/CollisionShapepollo2")

@onready var progress_bar: Node3D = player.get_node("Sprite3D")
@onready var original_bar_position: Vector3 = progress_bar.position
@onready var chicken_bar_position: Vector3 = original_bar_position - Vector3(0, CHICKEN_BAR_OFFSET_Y, 0)

# ---------------------------
# Variabili
# ---------------------------
var is_human: bool = true

# ---------------------------
# Funzioni
# ---------------------------
func _ready() -> void:
	connect("pressed", Callable(self, "_on_skin_button_pressed"))

func _on_skin_button_pressed() -> void:
	is_human = !is_human

	# Aggiorna visibilità dei modelli e collisioni
	_set_visibility(human_model, chicken_model, is_human)
	_set_visibility(human_collision, chicken_collision, is_human)
	_set_visibility(human_area_shape, chicken_area_shape, is_human)

			# Sposta la barra della vita in base al personaggio
	if is_human:
		progress_bar.position = original_bar_position  # ritorna alla posizione salvata
	else:
		var lowered = original_bar_position
		lowered.y -= 3.2  # abbassa la barra per il pollo
		progress_bar.position = lowered

# Helper per ridurre duplicazioni
func _set_visibility(human_node: Node, chicken_node: Node, human_visible: bool) -> void:
	human_node.visible = human_visible
	chicken_node.visible = not human_visible
