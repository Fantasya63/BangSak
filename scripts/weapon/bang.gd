extends BaseWeapon
class_name Bang


@export var bullet_prefab : PackedScene


func _ready():
	super._ready()


# Do not hide the icon of the seeker
func hide_icons():
	pass


func _process(delta):
	if not is_multiplayer_authority():
		return
	
	if Input.is_action_just_released("fire"):
		if cooldown_timer.time_left <= 0.0:
			fire()
			cooldown_timer.start(0.5)

func rpc_apply_fire():
	super.rpc_apply_fire()
	print_debug("RPC Fire - Position: " + str(fire_point.global_position))
	fire_sfx.pitch_scale = randf_range(0.9, 1.0)
	fire_sfx.play()
	
	var bullet : Bullet = bullet_prefab.instantiate()
	bullet.set_multiplayer_authority(multiplayer.get_unique_id())
	bullet.global_position = fire_point.global_position
	bullet.global_rotation = fire_point.global_rotation
	get_tree().root.get_node("Game").call_deferred("add_child", bullet)


func fire():
	super.fire()
	print_debug("Position: " + str(fire_point.global_position))
	
	fire_sfx.pitch_scale = randf_range(0.9, 1.0)
	fire_sfx.play()
	
	var bullet : Bullet = bullet_prefab.instantiate()
	bullet.set_multiplayer_authority(multiplayer.get_unique_id())
	bullet.global_position = fire_point.global_position
	bullet.global_rotation = fire_point.global_rotation
	get_tree().root.get_node("Game").call_deferred("add_child", bullet)
	#NetworkManager._request_spawn.rpc_id(1, bullet, "/root/Game")
