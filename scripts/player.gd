extends CharacterBody2D
class_name Player


@onready var anim : AnimatedSprite2D = $anim
@onready var footstep_audio_timer : Timer = $footstepTimer

@export_node_path("Label") var name_path
@onready var nametag : Label = get_node(name_path)

@onready var footstep_audios = [
	$footstep/footstepAudio1,
	$footstep/footstepAudio2,
	$footstep/footstepAudio3,
	$footstep/footstepAudio4,
]

@export var walk_speed := 75.0
@export var sprint_speed := 90.0
@export_range(0.0, 1.0) var anim_speed_scale := 0.01
@export var camera_prefab : PackedScene



enum TEAM { SEEKER, HIDER }
var team : TEAM

enum SPRITE_DIR { UP, DOWN, LEFT, RIGHT }
var sprite_dir : SPRITE_DIR = SPRITE_DIR.DOWN
var speed := 0.0

var player_info 


func _enter_tree():
	set_multiplayer_authority(name.to_int())


func _ready(): 
	anim.play("down_idle")
	
	
	if is_multiplayer_authority():
		team = TEAM.SEEKER
		var cam = camera_prefab.instantiate()
		add_child(cam)
	else:
		team = TEAM.HIDER


func _physics_process(delta):
	if speed > 0.0:
		play_footstep()
	
	if is_multiplayer_authority():
		var move_input := Vector2.ZERO
		
		if Input.is_action_pressed("up"):
			sprite_dir = SPRITE_DIR.UP
			move_input.y -= 1
		
		if Input.is_action_pressed("down"):
			sprite_dir = SPRITE_DIR.DOWN
			move_input.y += 1
		
		if Input.is_action_pressed("left"):
			sprite_dir = SPRITE_DIR.LEFT
			move_input.x -= 1
		
		if Input.is_action_pressed("right"):
			sprite_dir = SPRITE_DIR.RIGHT
			move_input.x += 1
		
		# Normalize the values to avoid moving faster when moving in a diagonal
		move_input = move_input.normalized()
		
		# Set the players velocity
		if Input.is_action_pressed("sprint"):
			velocity = move_input * sprint_speed
		else:
			velocity = move_input * walk_speed
	
	
	move_and_slide()
	play_anim()

func play_footstep():
	if footstep_audio_timer.time_left <= 0:
		var footstep_id = randi() % 4
		
		footstep_audios[footstep_id].pitch_scale = randf_range(0.8, 1.2)
		footstep_audios[footstep_id].play()
		footstep_audio_timer.start(0.25)


func play_anim():
	if is_multiplayer_authority():
		speed = velocity.length()
	
	if speed > 0.0:
		anim.speed_scale = speed * anim_speed_scale * 0.1
	else:
		anim.speed_scale = 1.0
	match sprite_dir:
		SPRITE_DIR.UP:
			# Dont flip the sprite
			anim.flip_h = false
			if speed > 0:
				anim.play("up_walk")
			else:
				anim.play("up_idle")
		
		SPRITE_DIR.DOWN:
			# Dont flip the sprite
			anim.flip_h = false
			if speed > 0:
				anim.play("down_walk")
			else:
				anim.play("down_idle")
		
		SPRITE_DIR.LEFT:
			# Dont flip the sprite
			anim.flip_h = true
			if speed > 0:
				anim.play("side_walk")
			else:
				anim.play("side_idle")
		
		SPRITE_DIR.RIGHT:
			# Dont flip the sprite
			anim.flip_h = false
			if speed > 0:
				anim.play("side_walk")
			else:
				anim.play("side_idle")
