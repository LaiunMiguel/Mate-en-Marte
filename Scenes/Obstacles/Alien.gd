extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var time_alive: Timer = $TimeAlive
@onready var projectile_scene: PackedScene = preload("res://Scenes/Obstacles/LaserProjectile.tscn")

var obstacle_speed : float = 200
var player_to_follow : Player 
var distance_to_player : float = 300;
var is_time_to_go : bool = false
var direction : int = 1
var projectile_velocity : float = 300
var vertical_speed: float = 400

func initialize(position:Vector2, player: Player):
	global_position = position
	player_to_follow = player
	distance_to_player = randf_range(320,370)
	time_alive.start(5)
	direction = [-1,1].pick_random()
	 

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _process(delta: float) -> void:
	if player_to_follow:
		var target_y = player_to_follow.global_position.y - distance_to_player
		global_position.y = move_toward(
			global_position.y,
			target_y,
			vertical_speed * delta
		)
		if is_time_to_go : 
			global_position.x += 5 * direction
	else: 
		global_position.x += 15 * direction 
	

	
func _on_time_alive_timeout() -> void:
	is_time_to_go = true


func _on_shooting_time_timeout() -> void:
	if player_to_follow:
		var projectile = projectile_scene.instantiate()
		projectile.initialize(global_position, player_to_follow ,projectile_velocity)
		get_parent().add_child(projectile)
	
	
	
