extends Control

signal facile
signal medio
signal difficile

func _on_facile_pressed() -> void:
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	$".".visible =  false
	facile.emit()


func _on_medio_pressed() -> void:
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	$".".visible =  false
	medio.emit()


func _on_difficile_pressed() -> void:
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished
	$".".visible =  false
	difficile.emit()


func _on_back_pressed() -> void:
	$AnimationPlayer.play_backwards("blur")
	await $AnimationPlayer.animation_finished 
	$".".visible =  false
