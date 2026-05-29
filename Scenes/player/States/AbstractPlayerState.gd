@abstract
extends AbstractState
class_name AbstractPlayerState

var player: Player

func _on_animation_finished(anim_name: StringName) -> void:
	pass

func handle_event(event: StringName, value = null) -> void:
	pass
