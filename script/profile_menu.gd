class_name ProfileMenu
extends Control
@onready var back_button = $MarginContainer/VBoxContainer/Back_button_2 as Button
@onready var name_label = $MarginContainer/VBoxContainer/nome
@onready var n_partite = $"MarginContainer/VBoxContainer/n partite"
@onready var tempomax_label = $"MarginContainer/VBoxContainer/tempo max"
@onready var tempolast_label = $"MarginContainer/VBoxContainer/tempo last"
@onready var good_food_label = $"MarginContainer/VBoxContainer/cibi buoni"
@onready var bad_food_label = $"MarginContainer/VBoxContainer/cibi cattivi"
@onready var tempotot_label = $"MarginContainer/VBoxContainer/tempo tot"
@onready var total_food_label = $"MarginContainer/VBoxContainer/cibi tot"

signal exit
	
func _ready() -> void:
	$AnimationPlayer.play("dark")
	await $AnimationPlayer.animation_finished

func _on_back_button_2_pressed() -> void:
	# Torna al menu principale
	#var menu_scene = load("res://scene/menu_principale.tscn")
	#get_tree().change_scene_to_packed(menu_scene)
	exit.emit()
