extends Node2D

@onready var player: Player = $Player
@onready var view_port: Vector2 = self.get_viewport_rect().size
@onready var camara_controller: Node = $CamaraController

#Points
var score : float

#Flags 
var ended: bool = false
var start: bool = false

#UI
@onready var button: Button = $CanvasLayer/Button
@onready var button_lose: Button = $CanvasLayer/Button_lose
@onready var distance: Label = $CanvasLayer/Distance
@onready var pause_menu: Control = $CanvasLayer/PauseMenu

#UI Temp
@onready var vidas = [
	$CanvasLayer/Life,
	$CanvasLayer/Life2,
	$CanvasLayer/Life3
]


#Scenary
@onready var killbox: Area2D = $Killbox
@onready var spawner: Node = $Spawner

func _ready() -> void:
	start = true
	

func _process(delta: float) -> void:
	if Input.is_action_pressed("reset"):
		get_tree().reload_current_scene()
	elif Input.is_action_pressed("pause"):
		_on_pausa_menu_pressed()
	
	if start:
		if !ended:
			if view_port.x < player.global_position.x - 50:
				player.global_position.x = 0
			elif player.global_position.x + 50 < 0:
				player.global_position.x = view_port.x	
			var reduced_dis      = - player.global_position.y / 100
			var distance_text = "DISTANCIA RECORRIDA: %.1f METROS"  % reduced_dis
			distance.text = distance_text
			
			


func _end_level():
	button_lose.visible = true
	var reduced_dis      = - player.global_position.y / 100
	distance.text = "TU DISTANCIA FINAL ES DE : %.1f METROS" %reduced_dis
	distance.position.y = (get_viewport_rect().size.y / 2 ) - 50
	ended = true
	player.lose()
	camara_controller.player_lose()

func _on_button_lose_pressed() -> void:
	get_tree().reload_current_scene()


func _on_player_player_lose() -> void:
	_end_level()


func _on_player_chage_life() -> void:
	for i in player.MAX_LIFE: 
		if i+1 > player.CURRENT_LIFE:
			vidas[i].play("empty")
		else:
			vidas[i].play("idle")


func _on_out_of_area_body_entered(body: Node2D) -> void:
	_end_level()


func _on_pausa_menu_pressed() -> void:
	get_tree().paused = true
	pause_menu.show()
	
