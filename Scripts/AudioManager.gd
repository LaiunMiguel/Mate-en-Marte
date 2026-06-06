extends Node

@onready var music_player := AudioStreamPlayer.new()



func _ready():
	add_child(music_player)
	music_player.bus = "Music"

func play_sfx(sound: AudioStream) -> void:
	var player := AudioStreamPlayer.new()
	player.bus = "SFX"

	player.stream = sound
	add_child(player)

	player.finished.connect(player.queue_free)
	player.pitch_scale = randf_range(0.95, 1.05)
	player.play()

func play_music(sound: AudioStream) -> void:
	music_player.stream = sound
	music_player.play()
	
