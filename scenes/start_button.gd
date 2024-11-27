extends Button



func _on_pressed():
	if GameManager.players.size() <= 1:
		return
	self.hide()
