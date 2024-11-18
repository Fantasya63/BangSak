extends Area2D
class_name Hitbox

signal on_bang_hit
signal on_sak_hit
signal on_stun_hit


func _apply_attack(attack : Attack):
	if not GameManager.is_game_started():
		return
	
	_process_attack(attack)


func _on_area_entered(area):
	if not area is HurtBox:
		return
	
	var attack : Attack = area.attack
	_process_attack(attack)


func _process_attack(attack : Attack):
	match attack.type:
		Attack.Bang:
			on_bang_hit.emit()
		Attack.Sak:
			on_sak_hit.emit()
		Attack.Stun:
			on_stun_hit.emit()
