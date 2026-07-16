extends Node

@onready var music_player := AudioStreamPlayer.new()
@onready var priority_music := AudioStreamPlayer.new()



func _ready():
	add_child(music_player)
	add_child(priority_music)

	music_player.bus = "Music"
	priority_music.bus = "Music"
	priority_music.finished.connect(_on_priority_music_finished)

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

func play_priority_music(sound: AudioStream):
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -15, 0.2)

	priority_music.stream = sound
	priority_music.play()
	
func stop_priority_music():
	var tween = create_tween()

	tween.parallel().tween_property(priority_music, "volume_db", -40, 0.2)
	tween.parallel().tween_property(music_player, "volume_db", 0, 0.2)

	await tween.finished

	priority_music.stop()
	priority_music.volume_db = 0	
	
func _on_priority_music_finished():
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", 0, 0.2)
