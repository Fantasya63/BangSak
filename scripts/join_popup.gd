extends PopupPanel

@onready var ip_input : LineEdit = $VBoxContainer/VBoxContainer/IPLineEdit
@onready var port_input : LineEdit = $VBoxContainer/VBoxContainer/PortLineEdit

# Regular expression to match IPv4 addresses
var ip_regex = RegEx.new()

func _ready():
	# Compile the regular expression for IPv4
	ip_regex.compile(r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")

func _on_join_btn_pressed():
	if is_valid_ip(ip_input.text):
		NetworkManager.join_game(ip_input.text)
		NetworkManager.load_game("res://scenes/game_scene.tscn")
	else:
		print_debug("Invalid IP address.")

# Function to validate the IP address
func is_valid_ip(ip: String) -> bool:
	if not ip_regex.search(ip):
		return false
	
	# Further validate each part of the IP is in the range 0-255
	var parts = ip.split(".")
	for part in parts:
		var number = int(part)
		if number < 0 or number > 255:
			return false
	return true
