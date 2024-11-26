extends Label

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	NetworkManager.on_player_name_reply.connect(_on_player_name_reply)
	

func _ready():
	NetworkManager.ask_player_name.rpc_id(1, multiplayer.get_unique_id())


func _on_player_name_reply(name, id):
	if id == $"..".name.to_int():
		text = name
