class_name Main_Menu
extends Control

@onready var Start_Button= $MarginContainer/HBoxContainer/VBoxContainer/Start_Button as Button
@onready var Exit_Button= $MarginContainer/HBoxContainer/VBoxContainer/Exit_Button as Button
@onready var Option_Button= $MarginContainer/HBoxContainer/VBoxContainer/Option_Button as Button
@onready var Level_button = $MarginContainer/HBoxContainer/VBoxContainer/Levels as Button
@onready var Credits_button = $MarginContainer/HBoxContainer/VBoxContainer/Credits as Button
@onready var Profile_button  = $MarginContainer/HBoxContainer/VBoxContainer/Profilo as Button
@onready var margin_cointainer= $MarginContainer as MarginContainer

@export var start_level = preload("res://scene/main.tscn")

@onready var Options_Menu= $Options_Menu as OptionMenu
@onready  var Levels_menu = $Levels_menu as LevelsMenu
@onready var Credits_menu = $Credits_Menu as CreditsMenu
@onready var Profile_menu = $Profile_Menu as ProfileMenu
@onready var New_Name = $NewName as NewName

@onready var name_label = $Profile_Menu/MarginContainer/VBoxContainer/nome
@onready var n_partite = $"Profile_Menu/MarginContainer/VBoxContainer/n partite"
@onready var tempomax_label = $"Profile_Menu/MarginContainer/VBoxContainer/tempo max"
@onready var tempolast_label = $"Profile_Menu/MarginContainer/VBoxContainer/tempo last"
@onready var good_food_label = $"Profile_Menu/MarginContainer/VBoxContainer/cibi buoni"
@onready var bad_food_label = $"Profile_Menu/MarginContainer/VBoxContainer/cibi cattivi"
@onready var tempotot_label = $"Profile_Menu/MarginContainer/VBoxContainer/tempo tot"
@onready var total_food_label = $"Profile_Menu/MarginContainer/VBoxContainer/cibi tot"

func _ready() -> void:
	handle_connecting_signals()
	$AnimationPlayer.play("dark_menu")
	$canvas/TextureRect2.modulate="ffffff00"
	$canvas/TextureRect3.modulate="ffffff00"
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$canvas/AnimationPlayer.play_backwards("visible")
	$canvas/ColorRect.visible = false
	await $AnimationPlayer.animation_finished
	
		
	await get_tree().create_timer(0.5).timeout
	# Controllo primo accesso
	if not FileAccess.file_exists(UserStats.save_path):
		New_Name.visible = true
		New_Name.get_node("AnimationPlayer").play("blur")
		$canvas/ColorRect.visible = true
		$canvas/AnimationPlayer.play("blur")
	else:
		UserStats.carica_statistiche()

func on_start_pressed() -> void:
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	$canvas/ColorRect.visible = false
	$canvas/TextureRect2.visible = false
	$canvas/TextureRect3.visible = false
	get_tree().change_scene_to_packed(start_level)
	
func on_exit_pressed() -> void:
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	$canvas/ColorRect.visible = false
	$canvas/TextureRect2.visible = false
	$canvas/TextureRect3.visible = false
	get_tree().quit()
	
func on_options_pressed() -> void:
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	$canvas/ColorRect.visible = false
	$canvas/TextureRect2.visible = false
	$canvas/TextureRect3.visible = false
	margin_cointainer.visible= false
	Options_Menu.visible=true
	$AnimationPlayer.play("dark_menu")
	await $AnimationPlayer.animation_finished

func on_levels_pressed() -> void:
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	$canvas/ColorRect.visible = false
	$canvas/TextureRect2.visible = false
	$canvas/TextureRect3.visible = false
	margin_cointainer.visible = false
	Levels_menu.visible = true
	$AnimationPlayer.play("dark_menu")
	await $AnimationPlayer.animation_finished
	
func on_credits_pressed() -> void:
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	$canvas/ColorRect.visible = false
	$canvas/TextureRect2.visible = false
	$canvas/TextureRect3.visible = false
	margin_cointainer.visible = false
	Credits_menu.visible = true
	$AnimationPlayer.play("dark_menu")
	await $AnimationPlayer.animation_finished
	
func _on_profile_pressed() -> void:
	UserStats.carica_statistiche()
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	$canvas/ColorRect.visible = false
	$canvas/TextureRect2.visible = false
	$canvas/TextureRect3.visible = false
	margin_cointainer.visible = false
	Profile_menu.visible = true
	name_label.text = "-   Ciao " + UserStats.user_name + "   -"
	n_partite.text = "Hai giocato " + str(UserStats.num_partite_giocate) + " partite" 
	tempomax_label.text = "score massimo: " + str(UserStats.tempo_massimo)
	tempolast_label.text = "score: " + str(UserStats.tempo_ultima)
	good_food_label.text = "cibi buoni: " + str(UserStats.total_good)
	bad_food_label.text = "cibi cattivi: " + str(UserStats.total_bad)
	tempotot_label.text = "totale tempo di gioco: " + str(UserStats.tempo_totale)
	total_food_label.text = "totale cibi raccolti: " + str(UserStats.total_food)

	$AnimationPlayer.play("dark_menu")
	await $AnimationPlayer.animation_finished
	

func on_exit_option_menu() -> void:
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	margin_cointainer.visible= true
	Options_Menu.visible=false
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$AnimationPlayer.play("dark_menu")
	$canvas/AnimationPlayer.play_backwards("visible")
	$canvas/ColorRect.visible = false
	await $AnimationPlayer.animation_finished
	
func _on_levels_menu_exit() -> void:
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	margin_cointainer.visible= true
	Levels_menu.visible=false
	$AnimationPlayer.play("dark_menu")
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$canvas/AnimationPlayer.play_backwards("visible")
	$canvas/ColorRect.visible = false
	await $AnimationPlayer.animation_finished

func _on_credits_menu_exit() -> void:
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	margin_cointainer.visible= true
	Credits_menu.visible=false
	$AnimationPlayer.play("dark_menu")
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$canvas/AnimationPlayer.play_backwards("visible")
	$canvas/ColorRect.visible = false
	await $AnimationPlayer.animation_finished
	
func _on_profile_menu_exit() -> void:
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	margin_cointainer.visible= true
	Profile_menu.visible=false
	$AnimationPlayer.play("dark_menu")
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$canvas/AnimationPlayer.play_backwards("visible")
	$canvas/ColorRect.visible = false
	await $AnimationPlayer.animation_finished
	


func handle_connecting_signals()-> void:
	Start_Button.button_down.connect(on_start_pressed)
	Option_Button.button_down.connect(on_options_pressed)
	Exit_Button.button_down.connect(on_exit_pressed)
	Options_Menu.exit_option_menu.connect(on_exit_option_menu)
	Level_button.button_down.connect(on_levels_pressed)
	Credits_button.button_down.connect(on_credits_pressed)
	Profile_button.button_down.connect(_on_profile_pressed)


func _on_options_menu_exit_option_menu() -> void:
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	margin_cointainer.visible= true
	Options_Menu.visible=false
	$AnimationPlayer.play("dark_menu")
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$canvas/AnimationPlayer.play_backwards("visible")

	$canvas/ColorRect.visible = false
	await $AnimationPlayer.animation_finished

func _on_texture_rect_2_mouse_entered() -> void:
	$canvas/TextureRect2.modulate="b8b8b8"
	$canvas/TextureRect3.modulate="b8b8b8"

func _on_texture_rect_2_mouse_exited() -> void:
	$canvas/TextureRect2.modulate="ffffff"
	$canvas/TextureRect3.modulate="ffffff"

func _on_texture_rect_2_pressed() -> void:
	$canvas/TextureRect2.modulate="979797"
	$canvas/TextureRect3.modulate="979797"
	await get_tree().process_frame
	$canvas/ColorRect.visible = true
	$canvas/TextureRect2.visible = true
	$canvas/TextureRect3.visible = true
	$canvas/AnimationPlayer.play("visible")
	$AnimationPlayer.play_backwards("dark_menu")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scene/ia_chatting_window.tscn")


func _on_texture_rect_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		$canvas/TextureRect2.modulate="979797"
		$canvas/TextureRect3.modulate="979797"
		await get_tree().process_frame
		$canvas/ColorRect.visible = true
		$canvas/TextureRect2.visible = true
		$canvas/TextureRect3.visible = true
		$canvas/AnimationPlayer.play("visible")
		$AnimationPlayer.play_backwards("dark_menu")
		await $AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scene/ia_chatting_window.tscn")


func _on_texture_rect_3_mouse_entered() -> void:
	$canvas/TextureRect3.modulate="b8b8b8"
	$canvas/TextureRect2.modulate="b8b8b8"


func _on_texture_rect_3_mouse_exited() -> void:
	$canvas/TextureRect3.modulate="ffffff"
	$canvas/TextureRect2.modulate="ffffff"
