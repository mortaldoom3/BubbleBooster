extends Control

@onready var level_label: Label = $MarginContainer/LevelNumber/LevelLabel
@export var level_number : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_label.text = "LEVEL : %s" % level_number

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
