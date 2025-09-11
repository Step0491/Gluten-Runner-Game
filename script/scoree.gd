extends Button

# ---------------------------
# Costanti statiche
# ---------------------------
const INITIAL_DELAY: float = 7.0
const INITIAL_TEXT: String = "Time: 0.00"

# ---------------------------
# Nodi onready con tipo esplicito
# ---------------------------
@onready var score_label: Button = $"."  # Il nodo Label stesso

# ---------------------------
# Variabili
# ---------------------------
var ok: bool = false
var elapsed_time: float = 0.0

# ---------------------------
# Funzioni
# ---------------------------
func _ready() -> void:
	score_label.text = INITIAL_TEXT
	await get_tree().create_timer(INITIAL_DELAY).timeout
	ok = true

func _process(delta: float) -> void:
	if ok:
		elapsed_time += delta
		score_label.text = "Time: %.2f\n" % elapsed_time
