extends Node

@onready var nubes_container: Node2D = $Nube/NubesContainer
@export var player_to_follow: Player
@export var director: Director

#Background
@onready var cielo:  = $Cielo/TextureRect
@onready var mars_parallax: Parallax2D = $MountainMars

const START_HEIGHT := 0
const END_HEIGHT := 200


func _process(delta: float) -> void:
	nubes_container.position.x += 0.2

	var level_start := director.next_distance_to_level_up - director.distance_to_level_up
	var level_end := director.next_distance_to_level_up

	var t := inverse_lerp(
		level_start,
		level_end,
		player_to_follow.distance_traveled
	)

	t = clamp(t, 0.0, 1.0)

	var color: Color

	match director.threat_lvl:
		0:
			color = Color(0.153, 0.608, 1.0, 1.0).lerp(
				Color(0.07, 0.15, 0.393, 1.0),
				t
			)

		1:
			color = Color(0.07, 0.15, 0.393, 1.0).lerp(
				Color.BLACK,
				t
			)

		2:
			color = Color.BLACK.lerp(
				Color(0.082, 0.014, 0.007, 1.0),
				t
			)

		3:
			color =Color(0.082, 0.014, 0.007, 1.0).lerp(
				Color(0.315, 0.083, 0.021, 1.0),
				t
			)

		4:
			# Victoria
			color = Color(0.315, 0.083, 0.021, 1.0)

	if director.threat_lvl == 3 && !mars_parallax.visible:
		mars_parallax.visible = true
	if mars_parallax.visible :
		$MountainMars/Sprite2D.position.y -= 0.1
	cielo.modulate = color
