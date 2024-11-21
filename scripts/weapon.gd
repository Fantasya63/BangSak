extends Node
class_name Weapon

@export_node_path("Node2D") var fire_point_path
@export var bullet_prefab : PackedScene

@onready var fire_point : Node2D = get_node(fire_point_path)
@onready var cooldown_timer : Timer = $cooldown_timer

@onready var fire_sfx : AudioStreamPlayer2D = $fire_sfx


func _ready():
	if not is_multiplayer_authority():
		set_process(false)
		set_process_input(false)


func _process(delta):
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_just_released("fire"):
		if cooldown_timer.time_left <= 0.0:
			fire()
			cooldown_timer.start(0.5)


@rpc("any_peer", "call_local", "reliable", 0)
func _spawn_bullet(bullet):
	get_tree().root.get_node("Game").call_deferred("add_child", bullet)


func fire():
	#print_debug("Position: " + str(fire_point.global_position))
	
	fire_sfx.pitch_scale = randf_range(0.9, 1.0)
	fire_sfx.play()
	
	#var bullet : Bullet = bullet_prefab.instantiate()
	#bullet.set_multiplayer_authority(multiplayer.get_unique_id())
	#bullet.global_position = fire_point.global_position
	#bullet.global_rotation = fire_point.global_rotation
	GameManager.request_spawn.rpc_id(1, bullet_prefab, multiplayer.get_unique_id(), fire_point.global_position, fire_point.global_rotation)
	#NetworkManager._request_spawn.rpc_id(1, bullet, "/root/Game")
