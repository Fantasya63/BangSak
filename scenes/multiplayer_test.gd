extends Node2D

var peer := ENetMultiplayerPeer.new()

@export var player_scene : PackedScene
@export_node_path("Control") var gui_path
@onready var gui : Control = get_node(gui_path)

func _on_host_pressed():
	peer.create_server(3307)
	gui.visible = false
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()


func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)


func _on_join_pressed():
	peer.create_client("localhost", 3307)
	multiplayer.multiplayer_peer = peer
	gui.visible = false
