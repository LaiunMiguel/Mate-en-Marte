extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sprite_2d_2: Sprite2D = $Sprite2D2


func initialize(initial_position,variant, rand_rotation):
	
	global_position = initial_position
	
	match variant:
		1:
			sprite_2d.visible = true
			sprite_2d_2.visible = false
			
		2:
			sprite_2d.visible = false
			sprite_2d_2.visible = true
			
		3:
			sprite_2d.visible = true
			sprite_2d_2.visible = true
	
	rotation_degrees  = rand_rotation


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.get_hit()


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
