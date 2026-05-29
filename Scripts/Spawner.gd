extends Node

@onready var view_port : float
@onready var timer: Timer = $Timer

@onready var camara_controller: CamaraController = $"../CamaraController"

##Dificulty control
@onready var dificulty_lvl_up: Timer = $Dificulty_lvl_up
@export var time_between_obstacles : float = 100
@export var number_of_obstacles_per_spawn : int = 1 
@export var min_velocity_of_obstacles : float = 100
@export var max_velocity_of_obstacles : float = 300
@export var min_obstacle_size : float = 0.9
@export var max_obstacle_size : float = 1.5
@export var time_to_lvl_up: float = 100


@export var obstacle_scene : PackedScene
@export var buff_list : Array[PackedScene]

func _ready() -> void:
	view_port = get_parent().get_viewport_rect().size.x
	dificulty_lvl_up.start(time_to_lvl_up)
	
	

	
func _on_spawn_timer_timeout() -> void:
	for i in range(number_of_obstacles_per_spawn):
		var obstacle = obstacle_scene.instantiate()
		get_parent().add_child(obstacle)
		var position : Vector2 = Vector2(randf_range(0,view_port),camara_controller.get_vertical_offscreen())
		var fall_speed : float = randf_range(min_velocity_of_obstacles,max_velocity_of_obstacles)
		var size : float = randf_range(min_obstacle_size,max_obstacle_size)
		obstacle.initialize(position,size,fall_speed)
	
func _on_dificulty_lvl_up_timeout() -> void:
	time_between_obstacles = max(0.2,time_between_obstacles - 0.5)
	number_of_obstacles_per_spawn += 1
	min_velocity_of_obstacles += 20
	max_velocity_of_obstacles += 20
	min_obstacle_size = max(0.1,min_obstacle_size - 0.1)
	max_obstacle_size = max(0.1,max_obstacle_size - 0.1)
	dificulty_lvl_up.start(time_to_lvl_up)


func _on_buff_spawn_timeout() -> void:
	var buff = buff_list.pick_random().instantiate()
	get_parent().add_child(buff)
	var position : Vector2 = Vector2(randf_range(0,view_port),camara_controller.get_vertical_offscreen())
	buff.initialize(position)

	
