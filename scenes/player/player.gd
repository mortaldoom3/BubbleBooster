extends RigidBody3D
class_name Player

## Fuerza de impulso
@export var thrust : float = 800.0
## Fuerza de giro
@export var torque_thrust : float = 150.0

@export_range(500.0, 2000.0) var prueba

var is_transitionig : bool = false
var show_arrow : bool = false

# Particles
@onready var left_bubble_particles: GPUParticles3D = $LeftBubbleParticles
@onready var right_bubble_particles: GPUParticles3D = $RightBubbleParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

#Sounds
@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var bubble_audio: AudioStreamPlayer = $BubbleAudio

# level number
#var level_number : int

var lives : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	lives = ScoreManager.get_lives()
	hiden_lives()
	$Arrow.visible = show_arrow
	#var landingpad_node = get_tree().get_first_node_in_group("landingpad")
	#if landingpad_node and landingpad_node.has_meta("file_path"):
		#print("sfddsfdfsdf")
		#var file_path : String = landingpad_node.get_meta("file_path")
		#var level_str = file_path[file_path.length() - 5] # Suponiendo que el número es de un solo dígito y está antes de '.tscn'
		#level_number = level_str.to_int()
		#print(level_number)
		#ScoreManager.set_level_selected(level_number - 1)
		
func _process(delta: float) -> void:
	hiden_lives()
	if Input.is_action_just_pressed("jump") and !show_arrow:
		show_arrow = true
		$Arrow.visible = show_arrow
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		
	if Input.is_action_pressed("jump"):
		apply_central_force(basis.y * delta * thrust)
		if !bubble_audio.playing:
			bubble_audio.play()
	else:
		bubble_audio.stop()
	
	if Input.is_action_pressed("left"):
		#rotate_z(delta)
		apply_torque(Vector3(0.0,0.0,torque_thrust) * delta)
		right_bubble_particles.emitting = true
	else:
		right_bubble_particles.emitting = false
		
	if Input.is_action_pressed("right"):
		#rotate_z(-delta)
		apply_torque(Vector3(0.0,0.0, -torque_thrust) * delta)
		left_bubble_particles.emitting = true
	else:
		left_bubble_particles.emitting = false
	
	

	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/ui/menu.tscn")

func _on_body_entered(body: Node) -> void:
	if !is_transitionig:
		if body.is_in_group("landingpad"):
			if body.file_path != null:
				call_deferred("complete_level",body.file_path)
		if body.is_in_group("obstacle"):
			call_deferred("crash_sequence")

func complete_level(next_level_file : String) -> void:
	right_bubble_particles.emitting = false
	left_bubble_particles.emitting = false
	success_particles.emitting = true
	$Arrow.visible = false
	#print("YOU WIN!!")
	set_physics_process(false)
	success_audio.play()
	bubble_audio.stop()
	is_transitionig = true
	var tween = create_tween()
	tween.tween_interval(1.2)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))
	
func crash_sequence() ->void:
	lives -= 1
	ScoreManager.set_lives(lives)
	hiden_lives()
	#print(lives)
	explosion_particles.emitting = true
	$Bubble01.visible = false
	$Arrow.visible = false
	right_bubble_particles.emitting = false
	left_bubble_particles.emitting = false
	explosion_audio.play()
	bubble_audio.stop()
	is_transitionig = true
	#print("YOU LOSE")
	set_process(false)
	set_physics_process(false)
	var tween = create_tween()
	tween.tween_interval(2.25)
	if lives > 0:
		tween.tween_callback(get_tree().reload_current_scene)
	else:
		ScoreManager.set_lives(3)
		call_deferred("_change_scene_with_delay")
		
func hiden_lives() -> void:
	if lives == 2:
		$"Control/MarginContainer/HBoxContainer/1".visible = false
	if lives == 1:
		$"Control/MarginContainer/HBoxContainer/1".visible = false
		$"Control/MarginContainer/HBoxContainer/2".visible = false
	if lives == 0:
		$"Control/MarginContainer/HBoxContainer/1".visible = false
		$"Control/MarginContainer/HBoxContainer/2".visible = false
		$"Control/MarginContainer/HBoxContainer/3".visible = false
		
func _change_scene_with_delay() -> void:
	await get_tree().create_timer(1.2).timeout
	get_tree().change_scene_to_file("res://scenes/ui/gameover.tscn")	
