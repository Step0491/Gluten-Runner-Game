extends Node3D

@export var speed: float = 4
@export var acceleration: float = 0.18
@export var check_z: float = -3.7
@export var destroy_z: float = -300

# Timer per controlli periodici
var destroy_timer: Timer

func _ready() -> void:
	# Timer per controllo destroy ogni 0.2 secondi
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

func _check_destroy() -> void:
	if position.z < destroy_z:
		queue_free()
