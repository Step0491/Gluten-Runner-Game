extends Node

var defaults = preload("res://script/SettingsResources.gd").new() # cambia il path se necessario

func _ready():
	await get_tree().create_timer(0.1).timeout
	apply_volumes(load("res://Resources/DefaultSettings.tres"))

func apply_volumes(settings: DefaultSettingsResource):
	# Volume lineare 1.0 = 0 dB
	var master_db = linear_to_db(settings.DEFAULT_MASTER_VOLUME)
	var music_db = linear_to_db(settings.DEFAULT_MUSIC_VOLUME)
	var sfx_db = linear_to_db(settings.DEFAULT_SFX_VOLUME)

	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), master_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), music_db)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), sfx_db)
