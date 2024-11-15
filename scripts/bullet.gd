extends CharacterBody2D
class_name Bullet

@export_node_path("Hitbox") var dmg_hit_path

@onready var cooldown_timer : Timer = $cooldown_timer
@onready var damage_hitbox : Hitbox = get_node(dmg_hit_path)

@export var initial_speed := 240.0
@export var target_speed := 240.0
@export var acceleration := 0.0
@export var lifespan := 1.0

var speed = initial_speed
var direction = Vector2.RIGHT


func _ready():
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	damage_hitbox.area_entered.connect(_on_enemy_hit)

	await get_tree().create_timer(lifespan).timeout
	queue_free()


func _physics_process(delta):
	speed = lerp(speed, target_speed, acceleration * delta)
	velocity = direction * speed * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()


func _on_enemy_hit():
	print_debug("Enemy Hit")
	queue_free()
