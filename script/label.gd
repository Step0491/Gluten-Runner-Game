extends Label

@onready var score_label = $"."  # Il nodo Label stesso

var elapsed_time : float = 0.0

func _process(delta: float) -> void:
	elapsed_time += delta

	score_label.text = "Time: %.1f\n" % elapsed_time
