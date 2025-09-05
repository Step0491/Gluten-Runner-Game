extends CanvasLayer

@onready var item_list      : ItemList = $Panel/VBox/ItemList
@onready var replay_button  : Button   = $Panel/VBox/Pulsanti/ReplayButton
@onready var menu_button    : Button   = $Panel/VBox/Pulsanti/MenuButton

# ------------------------------------------------------------------
func _ready() -> void:
	_popola_lista()

# ------------------------------------------------------------------
#  Popola la ItemList con percentuali
func _popola_lista() -> void:
	var data: Dictionary = GameState.raccolti

	if data.is_empty():
		item_list.add_item("Nessun alimento raccolto.")
		return

	# Calcolo del totale
	var totale: int = 0
	for v in data.values():
		totale += v

	for id in data.keys():
		var count : int = data[id]
		var perc  : int = int(round(100.0 * count / float(totale)))
		item_list.add_item("%s – %d%% (%d)" % [id.capitalize(), perc, count])
