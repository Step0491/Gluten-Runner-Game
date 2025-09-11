extends ProgressBar

const EMPTY_COLOR :Color= Color("red")
const FULL_COLOR :Color= Color("green")

func update_color():
	var t := value / max_value
	var color := FULL_COLOR.lerp(EMPTY_COLOR, 1.0 - t)

	var style := get_theme_stylebox("fill", "ProgressBar").duplicate()
	style.border_color = color
	style.bg_color = color
	add_theme_stylebox_override("fill", style)

func _on_value_changed(value: float) -> void:
	update_color()
