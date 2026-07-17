extends Control

var hover_tween: Tween
var base_scale: Vector2

func _ready():
	base_scale = scale

func _on_mouse_entered():
	AudioManager.play_sfx(AudioPreload.SELECT)
	var tween = create_tween()
	tween.tween_property(self, "scale", base_scale * 1.08, 0.15)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	modulate = Color(1.0, 1.0, 0.8)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "scale", base_scale, 0.15)

	modulate = Color.WHITE
