extends Button

@onready var score_label = $"."  # Il nodo Label stesso
var ok = false
var elapsed_time : float = 0.0

func _ready() -> void:
	await get_tree().create_timer(7).timeout
	ok=true
	
func _process(delta: float) -> void:
	score_label.text = "Time: 0.00"
	if ok:
		elapsed_time += delta

		score_label.text = "Time: %.1f\n" % elapsed_time
