extends BuffAbstract
@onready var invulnerable_time: Timer = $invulnerable_time
var player = null

func initialize(initial_position):
	global_position = initial_position

func handle_event(event):
	if (event.is_in_group("player")):
		player = event
		player._set_invulnerable(true)
		invulnerable_time.start(5)
		visible = false
		
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	handle_event(body)


func _on_invulnerable_time_timeout() -> void:
	player._set_invulnerable(false)
	queue_free() 


func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
