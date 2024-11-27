extends AudioStreamPlayer

func _ready():
	AudioManager.play_confirm_gui.connect(play_hover_sfx)
	
func play_hover_sfx():
	play()
