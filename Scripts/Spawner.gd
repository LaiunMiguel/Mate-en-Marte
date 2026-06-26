extends Node
class_name  Director

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
@export var max_obstacles_per_screen: int = 4
@export var distance_to_level_up: float = 100
@export var threat_lvl: int = 0 

#Player 
@onready var player: Player = $"../Player"
@export var next_distance_to_level_up : = 100

#Escenes
@export var obstacles_scenes: Array[PackedScene]
@export var buff_list : Array[PackedScene]
@export var scenary_scenes: Array[PackedScene]

#Containers 
@onready var obstacles_container: Node = $"../ObstaclesContainer"
@onready var scenary_container: Node = $"../ScenaryContainer"

#TEMP 
var patterns = [
	# Línea horizontal
	[
		Vector2(-120, 0),
		Vector2(0, 0),
		Vector2(120, 0)
	],

	# Diagonal
	[
		Vector2(-150, 0),
		Vector2(-50, -100),
		Vector2(50, -200),
		Vector2(150, -300)
	],

	# Diamante
	[
		Vector2(0, 0),
		Vector2(-100, -100),
		Vector2(100, -100),
		Vector2(0, -200)
	],

	# Laterales
	[
		Vector2(-180, 0),
		Vector2(180, 0),
		Vector2(-180, -150),
		Vector2(180, -150)
	]
]

var alien_formation = [
	[
		Vector2(-150, 0),
		Vector2(0, 0),
		Vector2(150, 0)
	],
	[
	Vector2(-180, 0),
	Vector2(180, 0),
	Vector2(0, -120)
	],
	[
	Vector2(-200, 0),
	Vector2(200, 0),
	Vector2(-100, -100),
	Vector2(100, -100),
	Vector2(0, -200)
	]	
]





func _ready() -> void:
	view_port = get_parent().get_viewport_rect().size.x
	
func _process(_delta: float) -> void:
	if player && player.distance_traveled >= next_distance_to_level_up:
		_dificulty_lvl_up()


func _on_spawn_timer_timeout() -> void:
	match threat_lvl:
		0: 
			_spawn_first_lvl()
		1:
			_spawn_second_lvl()
		2:
			_spawn_third_lvl()
		3:
			_spawn_four_lvl()
		4: 
			buff_spawn.stop()
		5:
			emit_signal("player_win")
		_:
			pass
	spawn_timer.start(time_between_obstacles)
	
func _spawn_first_lvl():
	for i in range(number_of_obstacles_per_spawn):
			if (obstacles_container.get_child_count() <= max_obstacles_per_screen):
				var obstacle = obstacles_scenes[0].instantiate()
				obstacles_container.add_child(obstacle)
				var offscreen = camara_controller.get_vertical_offscreen()
				var position : Vector2 = Vector2(
					randf_range(0,view_port),
					randf_range(offscreen,offscreen - 200)
					)
				var obstacle_speed : float = randf_range(100,150)
				obstacle.initialize(position,obstacle_speed)
				
func _spawn_second_lvl():
	for i in range(number_of_obstacles_per_spawn ):
			if (obstacles_container.get_child_count() <= max_obstacles_per_screen):
				var obstacle = obstacles_scenes[1].instantiate()
				obstacles_container.add_child(obstacle)
				var offscreen = camara_controller.get_vertical_offscreen()
				var position : Vector2 = Vector2(
					randf_range(0,view_port),
					randf_range(offscreen,offscreen - 200)
					)
				var size : float = randf_range(1,2)
				obstacle.initialize(position,size)

func _spawn_third_lvl():

	var amount = randi_range(1, 2)

	for i in amount:
		var pattern = patterns.pick_random()
		var offscreen = camara_controller.get_vertical_offscreen()
		var center_x = randf_range(200, view_port - 200)
		for offset in pattern:
			if obstacles_container.get_child_count() < max_obstacles_per_screen + 3:
				var obstacle = obstacles_scenes[randi_range(2, 3)].instantiate()
				obstacles_container.add_child(obstacle)
				var position = Vector2(
					center_x + offset.x,
					offscreen + offset.y
				)
				obstacle.initialize(
					position
				)
			
	for i in range(randi_range(2, 6)):
		if scenary_container.get_child_count() < 50:
			_spawn_scenery()

func _spawn_four_lvl():
	var formation = alien_formation.pick_random()
	var center_x = player.global_position.x
	var offscreen = camara_controller.get_vertical_offscreen()
	
	if obstacles_container.get_child_count() < 5:
		for offset in formation:
			var obstacle = obstacles_scenes[4].instantiate()
			obstacles_container.add_child(obstacle)
			var position = Vector2(
			center_x + offset.x,
			offscreen + offset.y
			)
			obstacle.initialize(position, player, offset)

func _spawn_scenery():
	var star = scenary_scenes[0].instantiate()
	scenary_container.add_child(star)
	var offscreen = camara_controller.get_vertical_offscreen()
	var position = Vector2(
		randf_range(0, view_port),
		offscreen
	)

	star.global_position = position

func _dificulty_lvl_up() -> void:
	time_between_obstacles = max(0.2,time_between_obstacles - 0.5)
	number_of_obstacles_per_spawn += 1
	next_distance_to_level_up += distance_to_level_up
	threat_lvl = min(threat_lvl+1,5)


func _on_buff_spawn_timeout() -> void:
	var buff = buff_list.pick_random().instantiate()
	get_parent().add_child(buff)
	var position : Vector2 = Vector2(randf_range(0,view_port),camara_controller.get_vertical_offscreen())
	buff.initialize(position)

func totaldistance() -> float:
	var total = distance_to_level_up + (next_distance_to_level_up * 4)
	return total
