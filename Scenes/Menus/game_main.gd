extends Node2D

@onready var player: Player = $Player
@onready var view_port: Vector2 = self.get_viewport_rect().size
@onready var camara_controller: Node = $CamaraController
@onready var director: Node = $Director

#UI
@onready var label_lose: Label = $CanvasLayer/UI/Lose/LabelLose
@onready var button_lose: Button = $CanvasLayer/UI/Lose/LabelLose/Button_lose
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var player_won_label: Label = $CanvasLayer/PlayerWonLabel
@onready var distance_label: Label = $CanvasLayer/UI/Stats/Stats/Distance/DistanceLabel
@onready var distance_number_label: Label = $CanvasLayer/UI/Stats/Stats/Distance/DistanceNumberLabel
@onready var timer_label: Label = $CanvasLayer/UI/Stats/Stats/Timer/TimerLabel
@onready var timer_number_label: Label = $CanvasLayer/UI/Stats/Stats/Timer/TimerNumberLabel
@onready var tiempo_transcurrido: Timer = $CanvasLayer/UI/Stats/Stats/Timer/TiempoTranscurrido


#UI TUTORIAL

@onready var tutorial_label: Label = $CanvasLayer/TutorialLabel


#UI Stats
@onready var vidas = [
	$CanvasLayer/UI/Life/Ui/Life,
	$CanvasLayer/UI/Life/Ui/Life2,
	$CanvasLayer/UI/Life/Ui/Life3
]
@onready var stats: Sprite2D = $CanvasLayer/UI/Stats/Stats
@onready var ui: Sprite2D = $CanvasLayer/UI/Life/Ui



var segundos_transcurridos : int = 0

#Screan Shake
@onready var color_rect: ColorRect = $CanvasLayer/ScreenShakeShader
@export var hit_shake_strength = 1;
@export var dead_shake_strength = 2;

#Flags 
var is_first_launch :bool = true
var ended: bool = false

#vars 
var distance_to_win: float = 0

var curStrength = 0;

func _ready() -> void:
	AudioManager.play_music(AudioPreload.MUSIC_TRACK_1)
	player.CURRENT_GRAVITY = 0
	player.global_position.x = get_viewport_rect().size.x / 2
	director.process_mode = Node.PROCESS_MODE_DISABLED
	distance_to_win = director.totaldistance()

func _process(delta: float) -> void: 
	
	if is_first_launch:
		if Input.is_action_just_pressed("aim"):
			tutorial_label.text = "Dependiendo de la distancia que arrastres es la fuerza con la que se lanzara"
		if Input.is_action_just_released("aim"):
			player.CURRENT_GRAVITY = player.GRAVITY
			director.process_mode = Node.PROCESS_MODE_INHERIT
			tiempo_transcurrido.start()
			_on_tiempo_transcurrido_timeout()
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
		var distance_left = distance_to_win - distance_travel
		var distance_text = "%.1f KM"  % distance_left
		
		distance_number_label.text = distance_text


func _end_level():
	ui.visible = false
	stats.visible = false
	var distance_travel = player.distance_traveled
	var distance_left = distance_to_win - distance_travel
	label_lose.visible = true
	label_lose.text = "UHHHH NO LOGRASTE LLEGAR A MARTE TE FALTARON %.1f KM" % distance_left
	
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

func _on_tiempo_transcurrido_timeout() -> void:
	segundos_transcurridos += 1
	var minutos := segundos_transcurridos / 60
	var segundos := segundos_transcurridos % 60
	timer_number_label.text = "%02d:%02d" % [minutos, segundos]
