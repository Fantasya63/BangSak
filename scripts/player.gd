extends CharacterBody2D

@onready var anim : AnimatedSprite2D = $anim

@export
var walk_speed := 75.0
@export_range(0.0, 1.0)
var anim_speed_scale := 0.01

var slipper_equipped = true
var slipper_cooldown = true
var slipper = preload("res://prefabs/slipper.tscn")

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
	
	move_and_slide()
	
	var mouse_pos = get_global_mouse_position()
	$Marker2D.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("Shoot") and slipper_equipped and slipper_cooldown:
		slipper_cooldown = false
		var slipper_instance = slipper.instantiate()
		slipper_instance.rotation = $Marker2D.rotation
		slipper_instance.global_position = $Marker2D.global_position
		call_deferred("add_child", slipper_instance)
		
		await get_tree().create_timer(0.4).timeout
		slipper_cooldown = true
		
	play_anim()
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
