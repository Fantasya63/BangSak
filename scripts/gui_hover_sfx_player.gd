extends AudioStreamPlayer

func _ready():
	AudioManager.play_gui_hover.connect(play_hover_sfx)
	
func play_hover_sfx():
	play()
