extends AbstractPlayerState

func enter() -> void:
	pass


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim"):
		finished.emit("aim")
	elif event.is_action_pressed("brake"):
		finished.emit("brake")

func update(delta: float) -> void:
	player._apply_movement(delta)
