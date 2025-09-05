extends Node3D  # o il nodo della scena


func _ready():
	$AnimationPlayer2.play("intro_move")
	await $AnimationPlayer2.animation_finished
