extends BuffAbstract

func initialize(position):
	global_position = position

func handle_event(event):
	if (event.is_in_group("player")):
		event.activateShield()
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	handle_event(body)


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
