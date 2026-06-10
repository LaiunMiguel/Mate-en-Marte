extends Node

@onready var sprite_2d: Sprite2D = $Nube/Sprite2D
@onready var sprite_2d_2: Sprite2D = $Nube/Sprite2D2


func _process(delta: float) -> void:
	sprite_2d.position.x += 0.1
	sprite_2d_2.position.x += 0.1
	
