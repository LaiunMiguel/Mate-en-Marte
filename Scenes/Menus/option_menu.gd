extends Control

signal save_option

@onready var bus_control: Control = $TextureRect/VBoxContainer/BusControl
@onready var bus_control_2: Control = $TextureRect/VBoxContainer/BusControl2
@onready var bus_control_3: Control = $TextureRect/VBoxContainer/BusControl3

	
func _on_save_button_pressed() -> void:
	emit_signal("save_option")
	
