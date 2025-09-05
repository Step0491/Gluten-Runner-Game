extends Node3D

@export var speed: float = 4
@export var acceleration: float = 0.18


@export var check_z: float = -3.7
@export var destroy_z: float = -300


func _physics_process(delta: float) -> void:
	speed += acceleration * delta
	position.z -= speed * delta

	if position.z < destroy_z:
		queue_free()
		
		
