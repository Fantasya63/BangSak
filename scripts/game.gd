extends Node2D

@onready var start_button : Button = $GUI/Button
@export_node_path("Node2D") var player_spawn_path 
@export var player_scene : PackedScene


# Called when the node enters the scene tree for the first time.
func _ready():
	if not multiplayer.is_server():
		start_button.visible = false
		
	NetworkManager.player_loaded.rpc_id(1)
	
	
	if multiplayer.is_server():
		NetworkManager.player_connected.connect(_add_player)
		_add_player(1, NetworkManager.player_info)


func _add_player(id, player_info):
	var player = player_scene.instantiate()
	player.name = str(id)
	get_node(player_spawn_path).call_deferred('add_child', player)
