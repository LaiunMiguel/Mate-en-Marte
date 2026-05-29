extends AbstractPlayerState

func enter() -> void:
	pass


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim"):
		finished.emit("aim")

func update(delta: float) -> void:
	player._apply_movement(delta)


func handle_event(event: StringName, value = null) -> void:
	pass
