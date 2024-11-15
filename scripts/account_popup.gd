extends Popup
class_name AccountPopup

@onready var username_input : LineEdit = $VBoxContainer/VBoxContainer/UsernameEdit


func set_username_text(_name: String):
	username_input.text = _name


func _on_save_btn_pressed():
	if username_input.text.is_empty():
		return
	
	NetworkManager.player_info['name'] = username_input.text
	self.visible = false