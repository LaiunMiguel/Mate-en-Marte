extends Line2D

@onready var player: Player = $"../../Player"

func _ready():
	hide()
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)

func _input(event):
	if event.is_action_pressed("aim"):
		show()
		position = get_viewport().get_mouse_position()
		set_point_position(0, Vector2.ZERO)

	elif event.is_action_released("aim"):
		hide()

func _process(_delta):
	if Settings.drag_line_enabled:
		if visible:
			var player_max_drag = player.MAX_DRAGG_DISTANCE + 50
			var drag = get_viewport().get_mouse_position() - position
			var t = clamp(
				drag.length() / player_max_drag,
				0.0,
				1.0
			)

			default_color = Color.WHITE.lerp(Color.RED, t)
			width = lerpf(4.0, 12.0, t)

			if drag.length() < player.MIN_DRAG_DISTANCE:
				set_point_position(1, Vector2.ZERO)
			else:
				if drag.length() > player_max_drag:
					drag = drag.normalized() * player_max_drag

				set_point_position(1, drag)
