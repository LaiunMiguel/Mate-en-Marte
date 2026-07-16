extends GPUParticles2D

var normalTexture = preload("uid://cqfjrhduyxema")


func  _ready() -> void:
	if !Settings.arg_mode:
		texture = normalTexture
