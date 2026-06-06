extends Node

@onready var view_port : float
@onready var camara_controller: CamaraController = $"../CamaraController"

#signal 
signal player_win

#timers
@onready var spawn_timer: Timer = $Spawn_timer
@onready var buff_spawn: Timer = $BuffSpawn


##Dificulty control
@export var time_between_obstacles : float = 1
@export var number_of_obstacles_per_spawn : int = 1 
@export var min_velocity_of_obstacles : float = 100
@export var max_velocity_of_obstacles : float = 300
@export var min_obstacle_size : float = 0.9
@export var max_obstacle_size : float = 1.5
@export var max_obstacles_per_screen: int = 4
@export var distance_to_level_up: float = 100
@export var threat_lvl: int = 0 

#Player 
@onready var player: Player = $"../Player"
@export var next_distance_to_level_up : = 100

@export var obstacles_scenes: Array[PackedScene]
@export var buff_list : Array[PackedScene]



#Max number of obstacles
@onready var obstacles_container: Node = $"../ObstaclesContainer"


func _ready() -> void:
	view_port = get_parent().get_viewport_rect().size.x
	
func _process(_delta: float) -> void:
	if player && player.distance_traveled >= next_distance_to_level_up:
		_dificulty_lvl_up()


func _on_spawn_timer_timeout() -> void:
	match threat_lvl:
		0: 
			_spawn_basic_obstacles()
		1:
			_spawn_medium_obstacles()
		2:
			_spawn_advanced_obstacles()
		3:
			emit_signal("player_win")
			spawn_timer.stop()
		_:
			pass
	spawn_timer.start(time_between_obstacles)
	
func _spawn_basic_obstacles():
	for i in range(number_of_obstacles_per_spawn):
			if (obstacles_container.get_child_count() <= max_obstacles_per_screen):
				var obstacle = obstacles_scenes[0].instantiate()
				obstacles_container.add_child(obstacle)
				var offscreen = camara_controller.get_vertical_offscreen()
				var position : Vector2 = Vector2(
					randf_range(0,view_port),
					randf_range(offscreen,offscreen - 200)
					)
				var obstacle_speed : float = randf_range(min_velocity_of_obstacles,max_velocity_of_obstacles)
				var size : float = randf_range(min_obstacle_size,max_obstacle_size)
				obstacle.initialize(position,size,obstacle_speed)

func _spawn_medium_obstacles():
	for i in range(number_of_obstacles_per_spawn + 2):
			if (obstacles_container.get_child_count() <= max_obstacles_per_screen + 1):
				var obstacle = obstacles_scenes[randi_range(1,2)].instantiate()
				obstacles_container.add_child(obstacle)
				var offscreen = camara_controller.get_vertical_offscreen()
				var position : Vector2 = Vector2(
					randf_range(0,view_port),
					randf_range(offscreen,offscreen - 200)
					)
				var obstacle_speed : float = randf_range(min_velocity_of_obstacles,max_velocity_of_obstacles)
				var size : float = randf_range(min_obstacle_size,max_obstacle_size)
				obstacle.initialize(position,size,obstacle_speed)
	

func _spawn_advanced_obstacles():
	for i in range(number_of_obstacles_per_spawn):
			if (obstacles_container.get_child_count() <= max_obstacles_per_screen):
				var obstacle = obstacles_scenes[3].instantiate()
				obstacles_container.add_child(obstacle)
				var offscreen = camara_controller.get_vertical_offscreen()
				var position : Vector2 = Vector2(
					randf_range(0,view_port),
					randf_range(offscreen,offscreen - 200)
					)
				obstacle.initialize(position, player)

func _dificulty_lvl_up() -> void:
	time_between_obstacles = max(0.2,time_between_obstacles - 0.5)
	number_of_obstacles_per_spawn += 1
	min_obstacle_size = min(1.5,min_obstacle_size + 0.1)
	max_obstacle_size = min(2.5,max_obstacle_size + 0.1)
	next_distance_to_level_up += distance_to_level_up
	threat_lvl = min(threat_lvl+1,3)


func _on_buff_spawn_timeout() -> void:
	var buff = buff_list.pick_random().instantiate()
	get_parent().add_child(buff)
	var position : Vector2 = Vector2(randf_range(0,view_port),camara_controller.get_vertical_offscreen())
	buff.initialize(position)

	
