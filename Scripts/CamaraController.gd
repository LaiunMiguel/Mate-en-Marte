extends Node
class_name CamaraController

@onready var camera : Camera2D = %Camara
@export var player_to_follow : Player

#Camara Config
@export var offset : float = 350.0
@export var smoothing : float = 5.0

#Margenes de spawn 
@export var top_margin : float = 200.0

func _ready() -> void:
	camera.limit_left = 0
	camera.limit_right = get_parent().get_viewport_rect().size.x 
	if player_to_follow :
		camera.global_position = player_to_follow.position
		camera.global_position.y -= offset

func _process(delta: float) -> void:
	if player_to_follow == null:
		return
	var new_pos = player_to_follow.position
	new_pos.y -= offset 
	
	if new_pos.y < camera.global_position.y:
		camera.global_position = camera.global_position.lerp(
			new_pos,
			smoothing * delta
		)

func center():
	return camera.get_screen_center_position()

func get_vertical_offscreen() -> float:
	var viewport_height = camera.get_viewport_rect().size.y
	var top_visible = camera.global_position.y - viewport_height / 2

	return top_visible - top_margin

func end_chase():
	set_process(false)
