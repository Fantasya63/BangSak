extends Node
class_name Weapon

@export_node_path("Node2D") var fire_point_path
@export var bullet_prefab : PackedScene

@onready var fire_point : Node2D = get_node(fire_point_path)
@onready var cooldown_timer : Timer = $cooldown_timer

func _ready():
	if not is_multiplayer_authority():
		set_process(false)
		set_process_input(false)

func _process(delta):
	if Input.is_action_just_released("fire"):
		if cooldown_timer.time_left <= 0.0:
			fire()
			cooldown_timer.start(0.5)

func fire():
	var bullet = bullet_prefab.instantiate()
	bullet.global_position = fire_point.global_position
	bullet.global_rotation = fire_point.global_rotation
	
	get_tree().root.get_node("Game").add_child(bullet)
