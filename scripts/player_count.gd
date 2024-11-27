extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	#GameManager.on_debug_rpc.connect(_debug_rpc)
	NetworkManager.player_connected.connect(_on_player_connected)


func _debug_rpc(senderID : int):
	self.text = "Debug rpc from " + str(senderID)

	
func _on_player_connected(new_player_id, new_player_info):
	text = str(NetworkManager.players.size()) + '/' +  str(NetworkManager.MAX_CONNECTIONS)
