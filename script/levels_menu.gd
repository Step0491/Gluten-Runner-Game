class_name LevelsMenu
extends Control

@export var start_level = preload("res://scene/main.tscn")
@onready var menu_dif = $"CanvasLayer/menu difficoltà"
@onready var animationP = menu_dif.get_node("AnimationPlayer")
var level=0

signal start_game
signal exit


func select_level() -> void:
	match(level):
		1:
			GameState.lv_corrente = GameState.lv.colazione
			get_tree().change_scene_to_packed(start_level)
		2:
			GameState.lv_corrente = GameState.lv.pranzo
			get_tree().change_scene_to_packed(start_level)
		3:
			GameState.lv_corrente = GameState.lv.cena
			get_tree().change_scene_to_packed(start_level)


func _on_back_button_pressed() -> void:
	#var menu_scene = load("res://scene/menu_principale.tscn")
	#get_tree().change_scene_to_packed(menu_scene)
	exit.emit()

func _on_level_1_button_pressed() -> void:
	menu_dif.visible=true
	animationP.play("blur")
	level=1

func _on_level_2_button_pressed() -> void:
	menu_dif.visible=true
	animationP.play("blur")
	level = 2

func _on_level_3_button_pressed() -> void:
	menu_dif.visible=true
	animationP.play("blur")
	level = 3

func _on_menu_difficoltà_facile() -> void:
	GameState.diff=1
	select_level()
	
func _on_menu_difficoltà_medio() -> void:
	GameState.diff=2
	select_level()
	
func _on_menu_difficoltà_difficile() -> void:
	GameState.diff=3
	select_level()
