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
	var item_scene = preload("res://prefabs//item.tscn").instantiate()
	item_scene.position = player.position
	call_deferred("add_child", player)
	call_deferred("add_child", item_scene)

#func _physics_process(delta: float) -> void:
	#randomize()
	#if Input.is_action_pressed("up"):
		#var item_scene = preload("res://prefabs//item.tscn").instantiate()
		#item_scene.position = Vector2(randf_range(10, 900), randf_range(10, 900))
		#call_deferred("add_child", item_scene)
		
		
func _on_join_pressed():
	peer.create_client("localhost", 3307)
	multiplayer.multiplayer_peer = peer
	gui.visible = false
