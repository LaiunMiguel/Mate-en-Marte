extends AbstractPlayerState

@onready var move_cooldown: Timer = $MoveCooldown
@onready var cooldown_bar: ProgressBar = $"../../CooldownBar"

func enter() -> void:
	move_cooldown.start(player.MOVE_COOLDOWN)
	cooldown_bar.max_value = player.MOVE_COOLDOWN
	cooldown_bar.value = player.MOVE_COOLDOWN
	cooldown_bar.visible = true


func exit() -> void:
	cooldown_bar.visible = false
	move_cooldown.stop()


func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("brake"):
		finished.emit("brake")


func update(delta: float) -> void:
	player._apply_movement(delta)
	cooldown_bar.value = move_cooldown.time_left



func handle_event(event: StringName, value = null) -> void:
	pass


func _on_move_cooldown_timeout() -> void:
	finished.emit("idle")
