extends Control

@onready var optionsMenu = "res://scene/pause_menu.tscn"
@onready var menu = "res://scene/menu_principale.tscn"

func _ready():
	$AnimationPlayer.play("RESET")

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	$"../../tasto_pausa/AnimationPlayer".play_backwards("visible")
	$"../../volume_button/AnimationPlayer".play_backwards("blur")
	$"../../info/AnimationPlayer".play_backwards("blur")
	$"../../skin_button/AnimationPlayer".play_backwards("blur")

	$"../../volume_button/ColorRect".visible=false
	$"../../info/ColorRect".visible=false
	$"../../skin_button/ColorRect".visible=false
	
func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	$"../../tasto_pausa/AnimationPlayer".play("visible")

func testEsc():
	if Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()
	elif Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()


func _on_resume_pressed():
	resume()


func _on_quit_pressed():
	get_tree().quit()
	PoolManager.reset_pools()


func _on_options_pressed():
	resume()
	get_tree().change_scene_to_file(optionsMenu)


func _on_restart_pressed() -> void:
	resume()
	PoolManager.reset_pools()
	var db = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))  # oppure "Musics"
	if db <= -79:
		$"../../volume_button/volume_btn"._on_pressed()
	get_tree().reload_current_scene()
	


func _on_menu_pressed() -> void:
	resume()
	PoolManager.reset_pools()
	get_tree().change_scene_to_file(menu)
