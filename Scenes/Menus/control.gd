extends NinePatchRect

@onready var hand: Sprite2D = $hand
@onready var hand_label: Label = $hand/HandLabel

var hand_start_position: Vector2
@onready var tutorial_label: Label = $TutorialLabel
var tutorial_step := 0
var original_position 



#Tweens
var tween_hint: Tween
signal tutorial_finish

func _ready():
	original_position = position
	hand_start_position = hand.position
	hold_hint()
	set_text("Mantené presionado")

func _input(event):
	if tutorial_step == 0 and Input.is_action_just_pressed("aim"):
		tween_hint.kill()
		drag_hint()
		tutorial_step = 1
		set_text("Arrastrá en dirección contraria para apuntar.")

	elif tutorial_step == 1 and Input.is_action_just_released("aim"):
		tutorial_step = 2
		_jump()
		set_text("¡Perfecto! Usá tus propulsiones y no caigas al vacío.")

		await get_tree().create_timer(2.0).timeout

	elif tutorial_step == 2 and Input.is_action_just_released("aim"):
		tutorial_step = 3
		set_text("¡Excelente! Esquivá los obstáculos y continuá tu viaje hacia Marte.")

		await get_tree().create_timer(2.0).timeout
		_fadeOut()
		

func _process(_delta):
	if tutorial_step == 1 and Input.is_action_pressed("aim"):
		position = original_position + Vector2(
			randf_range(-1, 1),
			randf_range(-1, 1)
		)

func set_text(text: String):
	tutorial_label.text = text

func _jump():
	position = original_position
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(1.15, 0.85), 0.08)
	tween.parallel().tween_property(self, "position", original_position + Vector2(0, 6), 0.08)
	tween.chain().parallel().tween_property(
		self,
		"position",
		original_position + Vector2(0, -20),
		0.18
	)
	tween.parallel().tween_property(self, "scale", Vector2.ONE, 0.18)
	tween.chain().tween_property(
		self,
		"position",
		original_position,
		0.12
	)

	await tween.finished
	
func _fadeOut():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	await tween.finished
	hide()
	emit_signal("tutorial_finish")
	queue_free()

func hold_hint():
	tween_hint = create_tween()
	tween_hint.set_loops()

	# Espera un poco antes de repetir
	tween_hint.tween_interval(0.5)

	# Presiona (baja un poco y se achica)
	tween_hint.parallel().tween_property(
		hand,
		"position",
		hand_start_position + Vector2(0, 10),
		0.15
	)
	tween_hint.parallel().tween_property(
		hand,
		"scale",
		Vector2(1.9, 1.9),
		0.15
	)

	tween_hint.tween_interval(0.3)
	tween_hint.parallel().tween_property(
		hand,
		"position",
		hand_start_position,
		0.15
	)
	tween_hint.parallel().tween_property(
		hand,
		"scale",
		Vector2(2, 2),
		0.15
	)
	
func drag_hint():
	
	hand_label.text = "DRAG"
	var tween = create_tween()
	tween.set_loops()

	# Espera antes de repetir
	tween.tween_interval(0.25)

	# Arrastra hacia atrás
	tween.tween_property(
		hand,
		"position",
		hand_start_position + Vector2(0, 75),
		0.6
	).set_trans(Tween.TRANS_QUAD)

	# Vuelve
	tween.tween_property(
		hand,
		"position",
		hand_start_position,
		0.6
	).set_trans(Tween.TRANS_QUAD)
