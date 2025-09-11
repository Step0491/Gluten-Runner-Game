extends StaticBody3D

# ---------------------------
# Costanti statiche
# ---------------------------
const DEFAULT_DESTROY_Z: float = -50.0

# ---------------------------
# Variabili esportate / tipizzate
# ---------------------------
@export var respawn_z: float = 114.0
@export var check_z: float = 40.0
@export var destroy_z: float = DEFAULT_DESTROY_Z

var speed: float = 3.6
var acceleration: float = 0.1
var spawn: bool = true

# ---------------------------
# Funzioni
# ---------------------------
func _physics_process(delta: float) -> void:
	# Aggiorna velocità e posizione
	speed += acceleration * delta
	position.z -= speed * delta

	if position.z < destroy_z:
		queue_free()
	elif spawn and position.z < check_z:
		spawn_clone()
		spawn = false

func spawn_clone() -> void:
	var clone: StaticBody3D = duplicate()
	clone.position = Vector3(position.x, position.y, respawn_z)
	clone.speed = speed
	clone.acceleration = acceleration
	get_parent().add_child(clone)

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		queue_free()
