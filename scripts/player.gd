extends CharacterBody2D

@onready var anim : AnimatedSprite2D = $anim

@export
var walk_speed := 75.0
@export_range(0.0, 1.0)
var anim_speed_scale := 0.01

enum SPRITE_DIR { UP, DOWN, LEFT, RIGHT }
var sprite_dir : SPRITE_DIR = SPRITE_DIR.DOWN

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready(): 
	anim.play("down_idle")

func _physics_process(delta):
	if not is_multiplayer_authority():
		return
	
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
	velocity = move_input * walk_speed
	
	play_anim()
	move_and_slide()


func play_anim():
	var speed := velocity.length()
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
