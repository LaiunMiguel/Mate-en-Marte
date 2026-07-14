extends Node2D

@onready var player: Player = $Player
@onready var view_port: Vector2 = self.get_viewport_rect().size
@onready var camara_controller: Node = $CamaraController
@onready var director: Node = $Director

#UI
@onready var pause_menu: Control = $CanvasLayer/PauseMenu
@onready var distance_label: Label = $CanvasLayer/UI/Stats/Stats/Distance/DistanceLabel
@onready var distance_number_label: Label = $CanvasLayer/UI/Stats/Stats/Distance/DistanceNumberLabel
@onready var timer_label: Label = $CanvasLayer/UI/Stats/Stats/Timer/TimerLabel
@onready var timer_number_label: Label = $CanvasLayer/UI/Stats/Stats/Timer/TimerNumberLabel
@onready var tiempo_transcurrido: Timer = $CanvasLayer/UI/Stats/Stats/Timer/TiempoTranscurrido

#UI END MENU
@onready var dead_menu: NinePatchRect = $CanvasLayer/UI/DeadMenu

#UI TUTORIAL
@onready var tutorial: NinePatchRect = $CanvasLayer/UI/Tutorial


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

#Win Animation
@onready var victory_player: AnimatedSprite2D = $VictoryPlayer
@onready var fade_out: ColorRect = $CanvasLayer/FadeOut


func _ready() -> void:
	fade_out.hide()
	ui.hide()
	stats.hide()
	AudioManager.play_music(AudioPreload.MUSIC_TRACK_1)
	player.CURRENT_GRAVITY = 0
	player.global_position.x = get_viewport_rect().size.x / 2
	director.process_mode = Node.PROCESS_MODE_DISABLED
	director.threat_lvl = -1

func _process(delta: float) -> void: 
	
	if is_first_launch:
		if Input.is_action_just_released("aim"):
			player.CURRENT_GRAVITY = player.GRAVITY
			director.process_mode = Node.PROCESS_MODE_INHERIT
			tiempo_transcurrido.start()
			_on_tiempo_transcurrido_timeout()
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
		var distance_left = max((distance_to_win - distance_travel),0)
		var distance_text = "%.1f KM"  % distance_left
		
		distance_number_label.text = distance_text


func _end_level():
	ui.hide()
	stats.hide()
	if tutorial:
		tutorial.hide()
	var distance_travel = player.distance_traveled
	var distance_left = distance_to_win - distance_travel
	dead_menu.endStats(timer_number_label.text, distance_left)
	dead_menu.show()
	ended = true
	player.lose()
	camara_controller.end_chase()

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
	var parallex_background: Node = $ParallexBackground
	parallex_background.show_mars_mountain()
	ended = true
	player.process_mode = PROCESS_MODE_DISABLED
	player.set_process(false)
	player.set_physics_process(false)
	
	camara_controller.end_chase()
	
	player.visible = false
	victory_player.global_position = player.global_position
	victory_player.visible = true
	
	var tween = create_tween() 
	tween.set_parallel(true) 
	tween.tween_property(victory_player, "global_position:x", 270, 0.5) 
	tween.tween_property(victory_player, "rotation_degrees", 180, 0.5) 
	await tween.finished
	tween.kill()
	tween = create_tween() 
	tween.tween_property(victory_player, "global_position:y", victory_player.global_position.y - 200, 1.5)
	await tween.finished
	await fade_out_animation()
	get_tree().change_scene_to_file("res://Scenes/Menus/EndGame.tscn")


func fade_out_animation():
	fade_out.show()
	var tween = create_tween()
	tween.tween_property(fade_out, "modulate:a", 1.0, 0.5)
	await tween.finished
	fade_out.hide()

func _on_tiempo_transcurrido_timeout() -> void:
	segundos_transcurridos += 1
	var minutos := segundos_transcurridos / 60
	var segundos := segundos_transcurridos % 60
	timer_number_label.text = "%02d:%02d" % [minutos, segundos]


func _on_tutorial_tutorial_finish() -> void:
	if !ended:
		director.game_beggin()
		distance_to_win = director.totaldistance()
		ui.show()
		stats.show()
		
