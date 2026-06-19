extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var obstacle_speed : float = 200
var direction : int = 1
var in_screen : int = 0

func initialize(initial_position:Vector2, speed: float):
	global_position = initial_position
	obstacle_speed = speed
	if position.x < 150:
		direction = 1
	elif position.x > 450:
		direction = -1
	else:
		direction = [-1, 1].pick_random()
	animated_sprite_2d.flip_h = direction > 0

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _process(delta: float) -> void:
	position.x += direction * obstacle_speed * delta * in_screen

	


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	in_screen = 1
