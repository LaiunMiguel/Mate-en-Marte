extends Control

@onready var option_menu: Control = $OptionMenu
@onready var color_rect: ColorRect = $ColorRect

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Menus/MenuPrincipal.tscn")


func _on_resume_button_pressed() -> void:
	hide()
	get_tree().paused = false


func _on_option_button_pressed() -> void:
	color_rect.hide()
	option_menu.show()


func _on_option_menu_save_option() -> void:
	color_rect.show()
	option_menu.hide()
