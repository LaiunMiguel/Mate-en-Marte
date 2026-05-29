extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var fall_speed : float = 200

func initialize(position:Vector2, size:float , fall: float):
	global_position = position
	collision_shape_2d.scale = Vector2(size,size)
	fall_speed = fall

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _process(delta: float) -> void:
	position.x -= fall_speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit(self)
