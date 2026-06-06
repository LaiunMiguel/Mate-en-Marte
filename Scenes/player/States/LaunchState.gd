extends AbstractPlayerState


func enter() -> void:
	
	_launch_player()

func _launch_player() -> void:
	player.slingshot()
	finished.emit("idle")


func exit() -> void:
	pass


func handle_input(event: InputEvent) -> void:
	pass


func update(delta: float) -> void:
	pass
