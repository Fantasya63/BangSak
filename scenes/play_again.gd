extends Button


func _ready():
	GameManager.game_ended.connect(_on_game_ended)


func _on_game_ended(winnerID : int):
	if multiplayer.is_server():
		self.show()
		#self.modulate = Color.WHITE
	else:
		self.hide()
		#self.modulate = Color.TRANSPARENT


func _on_pressed():
	if not multiplayer.is_server():
		return

	GameManager.play_again_pressed()
