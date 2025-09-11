extends Node3D

@export var speed: float = 4
@export var acceleration: float = 0.18

@export var respawn_z: float = 252.51
@export var check_z: float = -3.7
@export var destroy_z: float = -256
var spawn = true

# Timer per controlli periodici
var destroy_timer: Timer

func _ready() -> void:
	# Timer per controllo destroy
	destroy_timer = Timer.new()
	destroy_timer.wait_time = 5 
	destroy_timer.one_shot = false
	destroy_timer.autostart = true
	destroy_timer.connect("timeout", Callable(self, "_check_destroy"))
	add_child(destroy_timer)

func _physics_process(delta: float) -> void:
	# Aggiorna posizione con accelerazione
	speed += acceleration * delta
	position.z -= speed * delta

	# Spawn clone
	if position.z < check_z and spawn:
		spawn_clone()
		spawn = false

func spawn_clone() -> void:
	var clone = duplicate()  # Clone stesso nodo
	clone.position.z = respawn_z
	clone.position.x = position.x
	clone.speed = speed
	clone.acceleration = acceleration
	get_parent().add_child(clone)

func _check_destroy() -> void:
	if position.z < destroy_z:
		queue_free()
