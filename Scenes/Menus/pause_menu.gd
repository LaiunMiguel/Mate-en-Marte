extends Control

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/MenuPrincipal.tscn")


func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false
