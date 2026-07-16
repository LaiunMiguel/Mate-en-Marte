extends Control

signal save_option

@onready var bus_control: Control = $TextureRect/VBoxContainer/BusControl
@onready var bus_control_2: Control = $TextureRect/VBoxContainer/BusControl2
@onready var bus_control_3: Control = $TextureRect/VBoxContainer/BusControl3

	
func _on_save_button_pressed() -> void:
	emit_signal("save_option")
	


func _on_check_button_toggled(toggled_on: bool) -> void:
	Settings.drag_line_enabled = toggled_on


func _on_check_button_2_toggled(toggled_on: bool) -> void:
	Settings.show_tutorial = toggled_on


func _on_check_button_3_toggled(toggled_on: bool) -> void:
	Settings.arg_mode = toggled_on
