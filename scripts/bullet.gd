extends CharacterBody2D
class_name Bullet


@export var initial_speed := 240.0
@export var target_speed := 240.0
@export var acceleration := 0.0
@export var lifespan := 1.0

var speed = initial_speed
var direction = Vector2.RIGHT


@export_enum("Seeker", "Hider") var team : int

func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	await get_tree().create_timer(lifespan).timeout
	queue_free()


func _physics_process(delta):
	speed = lerp(speed, target_speed, acceleration * delta)
	velocity = direction * speed * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()


#func _on_hitbox_on_hitbox_collision(hitbox):
	#if not hitbox.team == team:
		#var attack := Attack.new()
		#attack.attack_type = Attack.ATTACK_TYPE.Bang
		#hitbox.do_attack(attack)
