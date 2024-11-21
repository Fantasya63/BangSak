extends BaseWeapon
class_name Slapper


var eliminated = false
@export var attack_range := 16.0
@onready var hurt_collider : CollisionShape2D = $Hurtbox/CollisionShape2D


func _ready():
	super._ready()
	
	hurt_collider.global_position = fire_point.global_position
	hurt_collider.set_deferred("disabled", true)
	
	if not is_multiplayer_authority():
		set_process(false)
		set_process_input(false)


func _process(delta):
	if not is_multiplayer_authority():
		return
	
	if eliminated:
		return
	
	if Input.is_action_just_released("fire"):
		if cooldown_timer.time_left <= 0.0:
			# Check distance
			var mouse_pos : Vector2 = get_global_mouse_position()
			var pos := fire_point.global_position
			
		
			fire()
			cooldown_timer.start(0.5)


func fire():
	fire_sfx.pitch_scale = randf_range(0.9, 1.0)
	fire_sfx.play()
	
	hurt_collider.set_deferred("disabled", false)



func _on_cooldown_timer_timeout():
	hurt_collider.set_deferred("disabled", true)
