extends Button

@export_enum("Master", "Musics") var target_bus: String = "Master"

const SOUND_ON_TEXTURE: Texture2D = preload("res://Resources/volume_bg.png")
const SOUND_OFF_TEXTURE: Texture2D = preload("res://Resources/mute_bg.png")

var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(target_bus)

	# Applica stato globale
	if VolumeState.is_muted:
		AudioServer.set_bus_volume_db(bus_index, -80)
	else:
		AudioServer.set_bus_volume_db(bus_index, VolumeState.saved_volume_db)

	call_deferred("update_button_style")

	if not is_connected("pressed", _on_pressed):
		connect("pressed", _on_pressed)

func _on_pressed():
	var current_db = AudioServer.get_bus_volume_db(bus_index)

	if current_db <= -79:
		AudioServer.set_bus_volume_db(bus_index, VolumeState.saved_volume_db)
		VolumeState.is_muted = false
	else:
		VolumeState.saved_volume_db = current_db
		AudioServer.set_bus_volume_db(bus_index, -80)
		VolumeState.is_muted = true

	update_button_style()

func update_button_style():
	var current_db = AudioServer.get_bus_volume_db(bus_index)

	var base_texture: Texture2D = SOUND_OFF_TEXTURE if current_db <= -79 else SOUND_ON_TEXTURE

	var normal_style := StyleBoxTexture.new()
	normal_style.texture = base_texture
	normal_style.set_content_margin_all(0)
	normal_style.modulate_color = Color.WHITE

	var hover_style := normal_style.duplicate()
	hover_style.modulate_color = Color("c6c6c6")

	var pressed_style := normal_style.duplicate()
	pressed_style.modulate_color = Color("9c9c9c")

	remove_theme_stylebox_override("normal")
	remove_theme_stylebox_override("hover")
	remove_theme_stylebox_override("pressed")

	add_theme_stylebox_override("normal", normal_style)
	add_theme_stylebox_override("hover", hover_style)
	add_theme_stylebox_override("pressed", pressed_style)

	queue_redraw()
