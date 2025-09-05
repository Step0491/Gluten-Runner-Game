extends StaticBody3D

var speed: float = 3.6
var acceleration: float = 0.1
@export var respawn_z: float = 114
@export var check_z: float = 40
@export var destroy_z: float = -45
var spawn = true

func _physics_process(delta: float) -> void:
	speed+= acceleration*delta
	position.z -= speed * delta
	
	# Rimuovi l'ostacolo quando è fuori schermo
	if position.z < -50:
		queue_free()
	if position.z < check_z and spawn:
		spawn_clone()
		spawn=false
		
func spawn_clone():
	var clone = duplicate()
	clone.position.z = respawn_z
	clone.position.x = position.x
	
	# Trasferisci la velocità e accelerazione attuali
	clone.speed = speed
	clone.acceleration = acceleration
	
	get_parent().add_child(clone)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()  # Rimuovi ostacolo in caso di collisione
