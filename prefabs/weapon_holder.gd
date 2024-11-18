extends Node2D

func _ready():
	if not is_multiplayer_authority():
		set_process(false)
		set_process_input(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var pos = global_position
	
	var direction = (mouse_pos - pos).normalized()
	#if Vector2.RIGHT.dot(direction) < 0.0:
		## Flip the sprite
		#pass 
	
	
	look_at(mouse_pos)
