extends Area2D
class_name HurtBox

@export var attack : Attack
signal on_hitbox_hurt


func _on_area_entered(area):
	if not GameManager.is_game_started():
		return
	
	if not area is Hitbox:
		return
	
	_process_attack(attack, area.playerID)
	on_hitbox_hurt.emit()


func _process_attack(attack : Attack, id :int):
	GameManager.attack_player.rpc_id(1, attack, id)
