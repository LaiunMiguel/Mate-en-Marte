extends NinePatchRect

@onready var time_label: Label = $Main/VBoxContainer/TimeLabel
@onready var distancia_label: Label = $Main/VBoxContainer/DistanciaLabel

func endStats(tiempo_total:String, distancia_restante: float):
	time_label.text = "Tu vuelo duro :" + tiempo_total
	distancia_label.text = "Marte quedó a %.1f km." % distancia_restante
	
func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Menus/MenuPrincipal.tscn")

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
