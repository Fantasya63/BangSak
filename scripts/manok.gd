extends CharacterBody2D


@onready var anim : AnimatedSprite2D = $anim
const SPEED = 50.0
const JUMP_VELOCITY = -400.0
var anim_list = ['idle']
var dir_list = ['back', 'front', 'side']
var dir_list_1 = ['back', 'front']
var dir = 'front'
var running = true
var gen = true

func _ready():
	anim.play("idle_back")
	
func _physics_process(delta: float) -> void:
	var move = Vector2.ZERO
	var num = randi_range(0, 40)
	
	if num == 40:
		# running = not running
		dir = dir_list_1.pick_random()
		
	if running:
		if dir == 'right':
			anim.flip_h = false
			move.x += 1
		if dir == "left":
			anim.flip_h = true
			move.x -= 1
		if dir == 'front':
			move.y += 1
		if dir == 'back':
			move.y -= 1
		if dir == 'left' or dir == 'right':
			dir = 'side'
		print(dir)
		anim.play("run_" + dir)
	velocity = move * SPEED
	move_and_slide()


func _on_anim_animation_looped() -> void:
	pass
	#if not running:
		#anim.play(anim_list.pick_random() + "_" + dir_list.pick_random())
	
