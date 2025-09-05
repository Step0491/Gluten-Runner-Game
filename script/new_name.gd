class_name NewName
extends Control
@onready var save_btn = $PanelContainer/VBoxContainer/salva as Button

signal save

func _ready() -> void:
	pass


func _on_salva_pressed() -> void:
	UserStats.first_time_name($PanelContainer/VBoxContainer/LineEdit.text)
	save.emit()
	$AnimationPlayer.play_backwards("blur")
	$"../canvas/AnimationPlayer".play_backwards("blur")
	await $AnimationPlayer.animation_finished
	await $"../canvas/AnimationPlayer".animation_finished 
	$"../canvas/ColorRect".visible=false
	$".".visible =  false
