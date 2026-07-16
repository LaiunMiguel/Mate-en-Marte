extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var time_alive: Timer = $TimeAlive
@onready var projectile_scene: PackedScene = preload("res://Scenes/Obstacles/LaserProjectile.tscn")

var obstacle_speed : float = 200
var player_to_follow : Player 
var distance_to_player : float = 500;
var is_time_to_go : bool = false
var direction : int = 1
var projectile_velocity : float = 300
var vertical_speed: float = 1000
var formation_offset : Vector2

var sound = []

func initialize(initial_position:Vector2, player: Player, offset:Vector2):
	global_position = initial_position
	player_to_follow = player
	distance_to_player = randf_range(450,500)
	time_alive.start(5)
	formation_offset = offset
	direction = [-1,1].pick_random()
	sound.append(AudioPreload.LASER_SHOOT1)
	sound.append(AudioPreload.LASER_SHOOT2)
	 

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _process(delta: float) -> void:
	if player_to_follow:
		var target_position = Vector2(
			player_to_follow.global_position.x + formation_offset.x,
			player_to_follow.global_position.y - 450 + formation_offset.y
		)

		global_position = global_position.move_toward(
			target_position,
			vertical_speed * delta
		)
		if is_time_to_go : 
			global_position.x += 200 * direction * delta
	else: 
		global_position.x += 200 * direction * delta
	

	
func _on_time_alive_timeout() -> void:
	is_time_to_go = true


func _on_shooting_time_timeout() -> void:
	if player_to_follow:
		var projectile = projectile_scene.instantiate()
		projectile.initialize(global_position, player_to_follow ,projectile_velocity)
		get_parent().get_parent().add_child(projectile)
		AudioManager.play_sfx(sound.pick_random())

	
	
	
