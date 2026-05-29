extends CharacterBody2D
class_name Player


@onready var line_2d: Line2D = $"../Line2D"
@onready var move_cooldown: Timer = $MoveCooldown
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# State variables
var mouse_start   : Vector2
var mouse_end     : Vector2


# Player stats
@export var MAX_LIFE:            int   = 3
@export var CURRENT_LIFE:        int   = 3
@export var MAX_DRAGG_DISTANCE:  float = 100.0
@export var MIN_DRAG_DISTANCE:   float = 20.0
@export var IMPULSE:             float = 8.0
@export var MAX_SPEED:           float = 750.0
@export var MOVE_COOLDOWN:       float = 0.5
@export var TIME_SLOW:           float = 0.4
@export var GRAVITY:             float = 300

#Player Stats flags
var invulerable: bool = false

#Signals
signal  player_change_life
signal  player_lose

#Score
@export var score : float = 0
@export var score_mul : float = 1 
@export var score_per_second : float = 1

func _apply_movement(delta: float) -> void:
	if velocity.length() > MAX_SPEED:
		velocity = velocity.normalized() * MAX_SPEED
		
	velocity.y += GRAVITY * delta
	move_and_slide()

func _process(delta: float) -> void:
	score += (score_per_second * score_mul) * delta

func slingshot():

	var drag_vector = mouse_end - mouse_start
	if drag_vector.length() > MAX_DRAGG_DISTANCE:
		drag_vector = drag_vector.normalized() * MAX_DRAGG_DISTANCE

	var direction = -drag_vector.normalized()
	var power = drag_vector.length() / MAX_DRAGG_DISTANCE
	var speed = power * MAX_SPEED
	velocity = direction * speed
		
func _rotate_sprite(vector: Vector2):
	var direction = -vector.normalized()
	rotation = direction.angle() + deg_to_rad(90)
	
func get_hit(type_of_obstacle):
	if !invulerable:
		CURRENT_LIFE -= 1
		emit_signal("player_change_life")
		animation_player.play("hit")
		if CURRENT_LIFE == 0:
			emit_signal("player_lose")
	
func lose():
	line_2d.queue_free()
	queue_free()
	
func gain_life():
	if CURRENT_LIFE < MAX_LIFE:
		CURRENT_LIFE += 1
		emit_signal("player_change_life")
	
func _set_invulnerable(boolean: bool):
	invulerable = boolean
	animation_player.stop()
	if (boolean):
		animation_player.play("star")
	else:
		animation_player.play("default")
	
	
