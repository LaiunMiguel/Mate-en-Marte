extends Node2D

@onready var win_photo: Sprite2D = $CanvasLayer/Control/WinPhoto
@onready var player_won_label: Label = $CanvasLayer/Control/PlayerWonLabel
@onready var credits: VBoxContainer = $CanvasLayer/Control/Credits
@onready var creditos_button: Button = $CanvasLayer/Control/CreditosButton
@onready var control: Control = $CanvasLayer/Control
const STAR_SCENARY = preload("uid://dmepk24ji4wgx")
@onready var background: Node2D = %Background


func _ready() -> void:
	AudioManager.play_music(AudioPreload.CREDITS)
	_spawn_scenery()
	win_photo.visible = true
	player_won_label.visible = true

	# Estado inicial
	win_photo.modulate.a = 0
	win_photo.scale = Vector2(4, 4)

	player_won_label.modulate.a = 0
	player_won_label.scale = Vector2(0.5, 0.5)

	await get_tree().create_timer(0.3).timeout

	# FOTO
	var photo_tween = create_tween()
	photo_tween.set_parallel(true)

	photo_tween.tween_property(win_photo, "modulate:a", 1.0, 1.2)
	photo_tween.tween_property(win_photo, "scale", Vector2(5, 5), 6)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)

	await photo_tween.finished

	await get_tree().create_timer(0.4).timeout

	# TEXTO
	var text_tween = create_tween()
	text_tween.set_parallel(true)

	text_tween.tween_property(player_won_label, "modulate:a", 1.0, 0.4)
	text_tween.tween_property(player_won_label, "scale", Vector2.ONE, 0.45)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)

	await text_tween.finished

	creditos_button.show()
	# Zoom lento continuo
	create_tween()\
		.tween_property(win_photo, "scale", Vector2(4.5, 4.5), 8.0)


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/MenuPrincipal.tscn")


func _on_creditos_button_pressed() -> void:
	var fade = create_tween()
	fade.tween_property(win_photo, "modulate:a", 0.0, 0.5)
	await fade.finished
	win_photo.visible = false
	player_won_label.visible = false
	credits.modulate.a = 0.0
	credits.show()

	create_tween().tween_property(credits, "modulate:a", 1.0, 0.8)
	
	var viewport_size = get_viewport_rect().size
	credits.position = Vector2(
		(viewport_size.x - credits.size.x) / 2,
		viewport_size.y
	)

	# Destino: completamente fuera por arriba
	var target_y = -credits.size.y - 50

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(credits, "position:y", target_y, 20.0)

	await tween.finished

	# Volver al menú automáticamente
	get_tree().change_scene_to_file("res://Scenes/Menus/MenuPrincipal.tscn")


func _spawn_scenery():
	randomize()

	var viewport_size = get_viewport_rect().size

	for i in range(100):
		var star = STAR_SCENARY.instantiate()

		# Posición aleatoria
		star.position = Vector2(
			randf_range(0, viewport_size.x),
			randf_range(0, viewport_size.y)
		)

		# Tamaño aleatorio
		var scale = randf_range(0.5, 1.8)
		star.scale = Vector2.ONE * scale

		# Transparencia aleatoria
		star.modulate.a = randf_range(0.4, 1.0)

		# Agregar al árbol
		background.add_child(star)

		# Animación aleatoria
		star.frame = randi_range(
			0,
			star.sprite_frames.get_frame_count("default") - 1
		)

		star.speed_scale = randf_range(0.5, 2.0)
		star.play()
