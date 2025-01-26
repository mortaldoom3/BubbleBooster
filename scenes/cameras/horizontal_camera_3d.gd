extends Camera3D

@onready var player: Player = $"../Player"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_position = player.global_transform.origin
	var camera_position = global_transform.origin
	camera_position.x = player_position.x
	global_transform.origin = camera_position
	
