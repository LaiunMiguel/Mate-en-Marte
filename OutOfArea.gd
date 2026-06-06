extends Area2D

@onready var camara: Camera2D = %Camara
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

func _process(_delta: float) -> void:
	var bottom = camara.global_position.y + (get_viewport_rect().size.y / 2) * camara.zoom.y
	collision_shape_2d.global_position.y = bottom + 20
