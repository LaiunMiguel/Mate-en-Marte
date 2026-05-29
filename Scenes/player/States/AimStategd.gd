extends AbstractPlayerState

var drag_vector

func enter() -> void:
	player.mouse_start = get_viewport().get_mouse_position()
	Engine.time_scale = move_toward(Engine.time_scale,player.TIME_SLOW,4.0)



func exit() -> void:
	player.mouse_end = get_viewport().get_mouse_position()
	Engine.time_scale = 1.0
	player.line_2d.clear_points()


func handle_input(event: InputEvent) -> void:
	if event.is_action_released("aim"):
		if drag_vector.length() > player.MIN_DRAG_DISTANCE:
			finished.emit("launch")
		else:
			finished.emit("idle")
			

func update(delta: float) -> void:
	player.line_2d.clear_points()
	
	drag_vector = get_viewport().get_mouse_position() - player.mouse_start
	
	if drag_vector.length() > player.MAX_DRAGG_DISTANCE:
		drag_vector = drag_vector.normalized() * player.MAX_DRAGG_DISTANCE
	
	player.line_2d.add_point(player.global_position)
	player.line_2d.add_point(player.global_position + drag_vector)
	player._rotate_sprite(drag_vector)
	player._apply_movement(delta)



func handle_event(event: StringName, value = null) -> void:
	pass
