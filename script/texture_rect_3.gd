extends TextureRect

func _ready() -> void:
	while true :
		$AnimationPlayer.play("moving")
		await $AnimationPlayer.animation_finished
		$AnimationPlayer.play_backwards("moving")
		await $AnimationPlayer.animation_finished
