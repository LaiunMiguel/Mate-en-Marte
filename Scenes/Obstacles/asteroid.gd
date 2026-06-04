extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var obstacle_speed : float = 200

func initialize(position:Vector2, size:float , speed: float):
	global_position = position
	scale = Vector2.ONE * size
	obstacle_speed = speed

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit(self)
