extends Area2D

var direction: Vector2
var speed: float
var player_to_follow

func initialize(spawn_point: Vector2, player: Player, projectile_speed: float):
	position = spawn_point
	player_to_follow = player
	direction = (player.global_position - spawn_point).normalized()
	speed = projectile_speed
	
	rotation = direction.angle()


func _process(delta):
	direction = direction.lerp(
		(player_to_follow.global_position - global_position).normalized(),
		2.0 * delta
	).normalized()

	rotation = direction.angle()
	position += direction * speed * delta

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()
