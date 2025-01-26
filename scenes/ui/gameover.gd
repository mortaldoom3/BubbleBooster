extends Control

@export_file var nextLevel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.




func _on_play_button_pressed() -> void:
	if nextLevel != null:
		get_tree().change_scene_to_file(nextLevel)



func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_about_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/ui/about.tscn")
