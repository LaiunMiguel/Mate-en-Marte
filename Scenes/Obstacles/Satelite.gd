extends Node2D

func initialize(position,size):
	global_position = position

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
