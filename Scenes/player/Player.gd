extends CharacterBody2D
class_name Player


@onready var line_2d: Line2D = $"../Line2D"
@onready var move_cooldown: Timer = $MoveCooldown
@onready var animated_sprite: AnimatedSprite2D = $animated_sprite
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var color_rect: ColorRect = $"../CanvasLayer/ColorRect"
@onready var state_machine: Node = $StateMachine


# State variables
var mouse_start   : Vector2
var mouse_end     : Vector2


# Player stats
@export var MAX_LIFE:            int   = 3
@export var CURRENT_LIFE:        int   = 3
@export var MAX_DRAGG_DISTANCE:  float = 125.0
@export var MIN_DRAG_DISTANCE:   float = 20.0
@export var BASE_MAX_SPEED:      float = 650
@export var CURRENT_MAX_SPEED:   float = 650.0
@export var MAX_SPEED:           float = 1050.0
@export var MOVE_COOLDOWN:       float = 0.5
@export var TIME_SLOW:           float = 0.4
@export var GRAVITY:             float = 300
@export var CURRENT_GRAVITY:     float = 300

#Signals
signal  player_hit
signal  player_heal
signal  player_lose

#Score deprecated
@export var score : float = 0
@export var score_mul : float = 1 
@export var score_per_second : float = 1

#Distance
var distance_traveled : float = 0;

#TEMP
@onready var max_velocity_timer: Timer = $MaxVelocityTimer

#Flags
@export var is_invulnerable: bool = false

func _ready() -> void:
	_distancia_traveled()
	
func _process(_delta: float) -> void:
	_distancia_traveled()

func _apply_movement(delta: float) -> void:
	if velocity.length() > CURRENT_MAX_SPEED:
		velocity = velocity.normalized() * CURRENT_MAX_SPEED
		
	velocity.y += CURRENT_GRAVITY * delta
	move_and_slide()

func _distancia_traveled() -> void:
	distance_traveled = - global_position.y / 100



func slingshot():
	scale = Vector2(1.3, 0.8)

	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15)

	var drag_vector = mouse_end - mouse_start
	if drag_vector.length() > MAX_DRAGG_DISTANCE:
		if CURRENT_MAX_SPEED < MAX_SPEED:
			CURRENT_MAX_SPEED += 100 
		max_velocity_timer.start()
		drag_vector = drag_vector.normalized() * MAX_DRAGG_DISTANCE

	var direction = -drag_vector.normalized()
	var power = drag_vector.length() / MAX_DRAGG_DISTANCE
	var speed = power * CURRENT_MAX_SPEED
	velocity = direction * speed
	_play_sound(AudioPreload.JUMP)
	
	

		
func _rotate_sprite(vector: Vector2):
	var direction = -vector.normalized()
	rotation = direction.angle() + deg_to_rad(90)
	
func get_hit():
	if !is_invulnerable:
		CURRENT_LIFE -= 1
		CURRENT_MAX_SPEED = BASE_MAX_SPEED
		velocity = velocity.normalized() * CURRENT_MAX_SPEED
		emit_signal("player_hit")
		animation_player.play("hit")
		_play_sound(AudioPreload.HIT_HURT)
		if CURRENT_LIFE == 0:
			emit_signal("player_lose")
	
func lose():
	line_2d.queue_free()
	hide()
	process_mode = Node.PROCESS_MODE_DISABLED
	


func gain_life():
	if CURRENT_LIFE < MAX_LIFE:
		CURRENT_LIFE += 1
		_play_sound(AudioPreload.POWER_UP)
		emit_signal("player_heal")
	
func _set_invulnerable(boolean: bool):
	animation_player.stop()
	if (boolean):
		animation_player.play("star")
		_play_sound(AudioPreload.POWER_UP)
	else:
		animation_player.play("default")
	
	
func _on_brake_button_pressed():
	var event := InputEventAction.new()
	event.action = "brake"
	event.pressed = true
	state_machine._input(event)

func play(animation : String):
	animation_player.play(animation)
	
func _play_sound(sound):
	AudioManager.play_sfx(sound)
	


func _on_max_velocity_timer_timeout() -> void:
	CURRENT_MAX_SPEED = max(BASE_MAX_SPEED , CURRENT_MAX_SPEED - 150)
