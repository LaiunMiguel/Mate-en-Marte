extends GenericStateMachine


@export var player : Player

func _setup() -> void:
	if player == null:
		printerr("%s: player is not defined!" % name)
	for state: AbstractPlayerState in states_list:
		state.player = player
