extends Label

@onready var authority_id : int = $"..".name.to_int()

# Called when the node enters the scene tree for the first time.
func _enter_tree():
	NetworkManager.on_player_name_reply.connect(_on_player_name_reply)

func _ready():
	NetworkManager.ask_player_name.rpc_id(1, authority_id)

func _on_player_name_reply(name, id):
	if id == authority_id:
		text = name
