extends Panel


func _ready():
	GameManager.game_ended.connect(_on_game_ended)
	GameManager.game_started.connect(_on_game_started)
	visible = false


func _on_game_started():
	visible = false
	
func _on_game_ended(winner : int):
	var playerID = multiplayer.get_unique_id()
	if winner == GameManager.get_team(playerID):
		visible = true
		$CenterContainer/HBoxContainer/Label.text = "You Won!"
	else:
		visible = true
		$CenterContainer/HBoxContainer/Label.text = "You Lost!"
	
	
