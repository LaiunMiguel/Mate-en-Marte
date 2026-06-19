extends Node2D

@onready var player: Player = $Player
@onready var view_port: Vector2 = self.get_viewport_rect().size
@onready var camara_controller: Node = $CamaraController
@onready var director: Node = $Director

#UI
@onready var button: Button = $CanvasLayer/Button
@onready var button_lose: Button = $CanvasLayer/Button_lose
@onready var distance: Label = $CanvasLayer/Distance
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var next_zone_bar: ProgressBar = $CanvasLayer/NextZoneBar
@onready var player_won_label: Label = $CanvasLayer/PlayerWonLabel
@onready var speed_label: Label = $CanvasLayer/SpeedLabel

#UI TUTORIAL
@onready var tutorial_label: Label = $CanvasLayer/TutorialLabel


#UI Temp
@onready var vidas = [
	$CanvasLayer/Life,
	$CanvasLayer/Life2,
	$CanvasLayer/Life3
]

#Screan Shake
@onready var color_rect: ColorRect = $CanvasLayer/ScreenShakeShader
@export var hit_shake_strength = 1;
@export var dead_shake_strength = 2;

#Flags 
var is_first_launch :bool = true
var ended: bool = false

var curStrength = 0;

func _ready() -> void:
	AudioManager.play_music(AudioPreload.MUSIC_TRACK_1)
	player.CURRENT_GRAVITY = 0
	player.global_position.x = get_viewport_rect().size.x / 2
	director.process_mode = Node.PROCESS_MODE_DISABLED
	next_zone_bar.min_value = 0
	next_zone_bar.max_value = director.next_distance_to_level_up
	next_zone_bar.value = player.distance_traveled
	

func _process(delta: float) -> void: 
	
	if is_first_launch:
		if Input.is_action_just_pressed("aim"):
			tutorial_label.text = "Dependiendo de la distancia que arrastres es la fuerza con la que se lanzara"
		if Input.is_action_just_released("aim"):
			player.CURRENT_GRAVITY = player.GRAVITY
			director.process_mode = Node.PROCESS_MODE_INHERIT
			tutorial_label.queue_free()
			is_first_launch = false
			
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	elif Input.is_action_pressed("pause"):
		_on_pausa_menu_pressed()

	curStrength = max(curStrength - delta, 0);
	color_rect.material.set_shader_parameter("ShakeStrength", max(curStrength,0))

	if !ended:
		if view_port.x < player.global_position.x - 50:
			player.global_position.x = 0
		elif player.global_position.x + 50 < 0:
			player.global_position.x = view_port.x
		var distance_travel = player.distance_traveled
		next_zone_bar.value = distance_travel
		if distance_travel > next_zone_bar.max_value:
			next_zone_bar.min_value = next_zone_bar.max_value
			next_zone_bar.max_value = director.next_distance_to_level_up
		var distance_text = "DISTANCIA RECORRIDA: %.1f METROS"  % distance_travel
		var velocity = player.velocity
		distance.text = distance_text
		speed_label.text = "VEL: %d | MAX: %d" % [
			int(velocity.length()),
			int(player.CURRENT_MAX_SPEED)
		]

func _end_level():
	button_lose.visible = true
	distance.text = "TU DISTANCIA FINAL ES DE : %.1f METROS" % player.distance_traveled
	distance.position.y = (get_viewport_rect().size.y / 2 ) - 50
	ended = true
	player.lose()
	camara_controller.player_lose()

func _on_button_lose_pressed() -> void:
	get_tree().reload_current_scene()


func _on_player_player_lose() -> void:
	_end_level()
	curStrength = dead_shake_strength


func _change_health() -> void:
	for i in player.MAX_LIFE: 
		if i+1 > player.CURRENT_LIFE:
			vidas[i].play("empty")
		else:
			vidas[i].play("idle")


func _on_out_of_area_body_entered(_body: Node2D) -> void:
	_end_level()


func _on_pausa_menu_pressed() -> void:
	get_tree().paused = true
	pause_menu.show()
	


func _on_player_player_hit() -> void:
	_change_health()
	curStrength = hit_shake_strength
	


func _on_player_player_heal() -> void:
	_change_health()
	


func _on_director_player_win() -> void:
	player_won_label.show()
	ended = true
	player.play("win")
	player.process_mode = Node.PROCESS_MODE_DISABLED
