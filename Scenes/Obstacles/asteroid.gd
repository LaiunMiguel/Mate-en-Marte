extends Area2D

var obstacle_speed : float = 200
var in_screen: bool = false

func initialize(initial_position:Vector2):
	global_position = initial_position
	rotation = randf_range(0, 360)

func _process(delta: float) -> void:
	if in_screen:
		rotate(0.1 * delta)
		global_position.y += obstacle_speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	in_screen = true
