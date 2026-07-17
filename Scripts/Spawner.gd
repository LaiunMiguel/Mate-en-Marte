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
@export var max_planes_per_screen : int = 4
@export var max_satelites_per_screen : int = 5
@export var max_asteroids_per_screen : int = 5

@export var number_of_planes_per_spawn : = 1
@export var number_of_saelites_per_spawn : = 1
@export var threat_lvl: int = 0 

#Distances 
@export var distance_first_level:  int  = 150
@export var distance_second_level: int  = 150
@export var distance_third_level:  int  = 150
@export var distance_fourd_level:  int  = 150
@export var distance_epiloge:      int  = 50

var distancesperlevel = []

#Player 
@onready var player: Player = $"../Player"
var next_distance_to_level_up : int

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

var distancia_agragada_en_el_tutorial



func _ready() -> void:
	_load_difficulty()
	view_port = get_parent().get_viewport_rect().size.x
	distancesperlevel.append(distance_first_level)
	distancesperlevel.append(distance_second_level)
	distancesperlevel.append(distance_third_level)
	distancesperlevel.append(distance_fourd_level)
	distancesperlevel.append(distance_epiloge)
	
	next_distance_to_level_up = distancesperlevel[threat_lvl]

func game_beggin():
	distancia_agragada_en_el_tutorial = player.distance_traveled
	next_distance_to_level_up += distancia_agragada_en_el_tutorial
	threat_lvl = 0 
	
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
	for i in range(number_of_planes_per_spawn):
			if (obstacles_container.get_child_count() <= max_planes_per_screen):
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
	var spawned_positions: Array[Vector2] = []

	for i in range(number_of_saelites_per_spawn):
			if (obstacles_container.get_child_count() >= max_satelites_per_screen):
				break
			var offscreen = camara_controller.get_vertical_offscreen()
			var position: Vector2
			var valid := false
				
			while !valid:
				position = Vector2(
					randf_range(0, view_port),
					randf_range(offscreen, offscreen - 200)
				)
				valid = true
			for p in spawned_positions:
				if position.distance_to(p) < 100: # Distancia mínima
					valid = false
					break

			var obstacle = obstacles_scenes[1].instantiate()
			obstacles_container.add_child(obstacle)
			
			var variant : int = randi_range(1,3)
			var rotations = [0, 45, 90, 135, 180, 225, 270, 315]
			obstacle.initialize(position,variant,rotations.pick_random())

func _spawn_third_lvl():

	var amount = randi_range(1, 2)
	
	for i in range(randi_range(2, 6)):
		if scenary_container.get_child_count() < 50:
			_spawn_scenery()

	for i in amount:
		var pattern = patterns.pick_random()
		if obstacles_container.get_child_count() + pattern.size() <= max_asteroids_per_screen:		
			var offscreen = camara_controller.get_vertical_offscreen()
			var center_x = randf_range(200, view_port - 200)
			for offset in pattern:
					var obstacle = obstacles_scenes[randi_range(2, 3)].instantiate()
					obstacles_container.add_child(obstacle)
					var position = Vector2(
						center_x + offset.x,
						offscreen + offset.y
					)
					obstacle.initialize(
						position
					)
			

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
	time_between_obstacles = max(0.4,time_between_obstacles - 0.5)
	threat_lvl = min(threat_lvl+1,5)
	next_distance_to_level_up +=  distancesperlevel[min(threat_lvl,4)]



func _on_buff_spawn_timeout() -> void:
	var buff = buff_list.pick_random().instantiate()
	get_parent().add_child(buff)
	var position : Vector2 = Vector2(randf_range(0,view_port),camara_controller.get_vertical_offscreen())
	buff.initialize(position)

func totaldistance() -> float:
	var total: int
	for dis in distancesperlevel:
		total += dis
	total += distancia_agragada_en_el_tutorial

	return total
	
func get_next_distance_to_level_up() -> float:
	return next_distance_to_level_up

func get_distance_to_level_up() -> float:
	return distancesperlevel[min(threat_lvl,4)]
	
	
func _load_difficulty() -> void:
	match Settings.difficulty:
		Settings.Difficulty.EASY:
			buff_spawn.wait_time = 4
			number_of_planes_per_spawn = 1 
			number_of_saelites_per_spawn = 1
			max_planes_per_screen = 3
			max_satelites_per_screen = 3
			max_asteroids_per_screen = 5


			distance_first_level = 150
			distance_second_level = 150
			distance_third_level = 100
			distance_fourd_level = 100
			distance_epiloge = 25

		Settings.Difficulty.NORMAL:
			buff_spawn.wait_time = 5.0
			number_of_planes_per_spawn = 1 
			number_of_saelites_per_spawn = 2
			max_planes_per_screen = 4
			max_satelites_per_screen = 5
			max_asteroids_per_screen = 5

			distance_first_level = 150
			distance_second_level = 150
			distance_third_level = 150
			distance_fourd_level = 150
			distance_epiloge = 50

		Settings.Difficulty.HARD:
			buff_spawn.wait_time = 5.0
			number_of_planes_per_spawn = 2 
			number_of_saelites_per_spawn = 3
			max_planes_per_screen = 5
			max_satelites_per_screen = 6
			max_asteroids_per_screen = 6

			distance_first_level = 100
			distance_second_level = 150
			distance_third_level = 200
			distance_fourd_level = 200
			distance_epiloge = 50

		Settings.Difficulty.VERYHARD:
			buff_spawn.wait_time = 10
			number_of_planes_per_spawn = 2 
			number_of_saelites_per_spawn = 4
			max_planes_per_screen = 6
			max_satelites_per_screen = 7
			max_asteroids_per_screen = 7

			distance_first_level = 150
			distance_second_level = 150
			distance_third_level = 300
			distance_fourd_level = 300
			distance_epiloge = 50
