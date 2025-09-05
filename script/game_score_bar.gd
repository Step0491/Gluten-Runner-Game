extends ProgressBar

const EMPTY_COLOR := Color("red")
const FULL_COLOR := Color("green")

func _ready():
	# Usa direttamente il valore calcolato da GameStats
	value = GameStats.estimated_quality_percent
	update_color()
	
func update_color():
	var t := value / max_value
	var color := FULL_COLOR.lerp(EMPTY_COLOR, 1.0 - t)

	var style := get_theme_stylebox("fill", "ProgressBar").duplicate()
	style.border_color = color
	style.bg_color = color
	add_theme_stylebox_override("fill", style)
