extends Node2D

@onready var label: Label = $CanvasLayer/Label
@onready var option_menu: Control = $CanvasLayer/OptionMenu
@onready var game_menu: VBoxContainer = $CanvasLayer/GameMenu
@onready var dificulty_selector: VBoxContainer = $CanvasLayer/DificultySelector

func _ready():
	AudioManager.play_music(AudioPreload.MUSIC_TRACK_1)

	var tween = create_tween()
	tween.set_loops()

	tween.parallel().tween_property(label, "position:y", label.position.y - 10, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(label, "scale", Vector2.ONE * 1.05, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(label, "position:y", label.position.y, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(label, "scale", Vector2.ONE, 1.2)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
		
func _on_play_button_pressed() -> void:
	game_menu.hide()
	dificulty_selector.show()


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_option_menu_save_option() -> void:
	option_menu.hide()


func _on_options_button_pressed() -> void:
	option_menu.show()
	

func _change_level():
	get_tree().change_scene_to_file("res://Scenes/Menus/GameScene.tscn")

func _on_facil_pressed() -> void:
	Settings.difficulty = Settings.Difficulty.EASY
	_change_level()


func _on_normal_pressed() -> void:
	Settings.difficulty = Settings.Difficulty.NORMAL
	_change_level()

func _on_dificil_pressed() -> void:
	Settings.difficulty = Settings.Difficulty.HARD
	_change_level()


func _on_imposible_pressed() -> void:
	Settings.difficulty = Settings.Difficulty.VERYHARD
	_change_level()
