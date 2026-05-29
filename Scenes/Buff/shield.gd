extends BuffAbstract
@onready var invulnerable_time: Timer = $invulnerable_time

func initialize(position):
	global_position = position

func handle_event(event):
	if (event.is_in_group("player")):
		event._set_invulnerable(true)
		invulnerable_time.start(5) 
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("body enter")
	handle_event(body)
