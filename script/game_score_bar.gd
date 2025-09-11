extends ProgressBar

const EMPTY_COLOR : Color = Color("red")
const FULL_COLOR  : Color = Color("green")

# 🔹 Funzione statica riutilizzabile per calcolare il colore in base a t
static func get_bar_color(t: float, full: Color = FULL_COLOR, empty: Color = EMPTY_COLOR) -> Color:
	t = clamp(t, 0.0, 1.0)  # sicurezza
	return full.lerp(empty, 1.0 - t)

func _ready():
	value = GameStats.estimated_quality_percent
	update_color()

func update_color():
	var t : float = value / max_value
	var color :Color = get_bar_color(t)

	# Duplica e aggiorna lo stylebox in modo sicuro
	var style := get_theme_stylebox("fill", "ProgressBar").duplicate()
	style.border_color = color
	style.bg_color = color
	add_theme_stylebox_override("fill", style)
