extends Area2D
class_name Hitbox

@export_enum("Seeker", "Hider") var team : int
#@export_node_path("CollisionShape2D") var collider_path
#@onready var collider : CollisionShape2D = get_node(collider_path)

signal on_hitbox_collision

func _on_area_entered(area : Hitbox):
	if area.team == team:
		return
	
	emit_signal("on_hitbox_collision")
