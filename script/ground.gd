extends MeshInstance3D

var offset = 0.0
var speed = 0.8
var acceleration = 0.018

func _process(delta: float) -> void:
	speed += acceleration * delta
	offset -= speed * delta
	if offset <= -1:
		offset = 0
	get_active_material(0).uv1_offset.y = offset
