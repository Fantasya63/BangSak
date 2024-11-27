extends BaseButton

func _ready():
	self.mouse_entered.connect(on_mouse_entered)
	self.pressed.connect(on_pressed)

func on_mouse_entered():
	AudioManager.emit_signal("play_gui_hover")

func on_pressed():
	AudioManager.play_confirm_gui.emit()
