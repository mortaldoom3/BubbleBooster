extends Camera3D


@onready var player: Player = $"../Player"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	var player_position = player.global_transform.origin
	
	var camera_position = global_transform.origin
	

	camera_position.x = player_position.x
	camera_position.y = player_position.y

	global_transform.origin = camera_position
