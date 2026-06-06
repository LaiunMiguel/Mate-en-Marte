extends Control

@export var bus_name := "Master"

@onready var label: Label = $ColorRect/Label
@onready var h_slider: HSlider = $ColorRect/HSlider

func _ready() -> void:
	label.text = bus_name

	var bus_index = AudioServer.get_bus_index(bus_name)
	h_slider.value = db_to_linear(
		AudioServer.get_bus_volume_db(bus_index)
	)

func _on_h_slider_value_changed(value: float) -> void:
	var bus_index = AudioServer.get_bus_index(bus_name)

	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
