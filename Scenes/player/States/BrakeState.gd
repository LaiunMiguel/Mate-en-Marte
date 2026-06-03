extends AbstractPlayerState

const BRAKE_FORCE := 1000.0
@onready var brake_duration: Timer = $BrakeDuration

func enter() -> void:
	brake_duration.start(0.5)
	print("enter")

func exit() -> void:
	brake_duration.stop()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("aim"):
		finished.emit("aim")



func update(delta: float) -> void:
	player.velocity = player.velocity.move_toward(
		Vector2.ZERO,
		BRAKE_FORCE * delta
	)
	player._apply_movement(delta)
	
	


func handle_event(event: StringName, value = null) -> void:
	pass


func _on_brake_duration_timeout() -> void:
	finished.emit("idle")
