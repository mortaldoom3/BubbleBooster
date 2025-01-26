extends Control

@export_file var nextLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ScoreManager.set_level_selected(1)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	if nextLevel != null:
		get_tree().change_scene_to_file(nextLevel)


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/about.tscn")
