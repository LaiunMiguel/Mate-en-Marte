extends BuffAbstract

func initialize(initial_position):
	global_position = initial_position

func handle_event(event):
	if (event.is_in_group("player")):
		event.gain_life()
		
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	handle_event(body)
