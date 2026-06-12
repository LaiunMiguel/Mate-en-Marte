extends AbstractPlayerState


func enter() -> void:
	
	_launch_player()

func _launch_player() -> void:
	player.slingshot()
	finished.emit("idle")


func exit() -> void:
	pass


func handle_input(_event: InputEvent) -> void:
	pass


func update(_delta: float) -> void:
	pass
