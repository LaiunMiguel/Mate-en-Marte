extends Label

@export var power_name := ""
var power_label_tween: Tween

func _ready():
	if power_label_tween:
		power_label_tween.kill()

	text = power_name
	visible = true
	modulate.a = 0.0
	scale = Vector2(0.8, 0.8)

	var start_y = position.y

	power_label_tween = create_tween()

	power_label_tween.set_parallel(true)
	power_label_tween.tween_property(self, "modulate:a", 1.0, 0.2)
	power_label_tween.tween_property(self, "scale", Vector2.ONE, 0.2)

	power_label_tween.set_parallel(false)
	power_label_tween.tween_interval(1.0)

	power_label_tween.set_parallel(true)
	power_label_tween.tween_property(self, "modulate:a", 0.0, 0.5)
	power_label_tween.tween_property(self, "position:y", start_y - 15, 0.5)

	await power_label_tween.finished

	queue_free()
