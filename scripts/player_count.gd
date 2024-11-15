extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	NetworkManager.player_connected.connect(_on_player_connected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_player_connected(new_player_id, new_player_info):
	text = str(NetworkManager.players.size()) + '/' +  str(NetworkManager.MAX_CONNECTIONS)
