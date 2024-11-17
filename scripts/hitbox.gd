extends Area2D
class_name Hitbox

signal on_bang_hit
signal on_sak_hit
signal on_stun_hit

func _apply_attack(attack : Attack):
	if not GameManager.is_game_started():
		return
	
	match attack.type:
		Attack.Bang:
			on_bang_hit.emit()
		Attack.Sak:
			on_sak_hit.emit()
		Attack.Stun:
			on_stun_hit.emit()


func _on_area_entered(area):
	if not GameManager.is_game_started():
		return
	
	if area is HurtBox:
		var attack : Attack = area.attack
		
		match attack.type:
			Attack.Bang:
				on_bang_hit.emit()
			Attack.Sak:
				on_sak_hit.emit()
			Attack.Stun:
				on_stun_hit.emit()
