extends Node2D

@onready var start_button : Button = $GUI/Button
@export var player_scene : PackedScene

# The node where the player will be parented
@export_node_path("Node2D") var player_spawn_parent

# A node that contains a children of player spawn positions to chose from
@export_node_path("Node") var player_spawn_positions_path
@export_node_path("Timer") var countdown_timer_path


@onready var countdown_timer : Timer = get_node(countdown_timer_path)
var player_spawn_positions : Array


# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug(multiplayer.get_unique_id())
	
	GameManager.game_started.connect(_on_game_started)
	player_spawn_positions = get_node(player_spawn_positions_path).get_children()
	
	if not multiplayer.is_server():
		start_button.visible = false
		
	NetworkManager.player_loaded.rpc_id(1)

	if multiplayer.is_server():
		NetworkManager.player_connected.connect(_add_player)
		_add_player(1, NetworkManager.player_info)


func _add_player(id, player_info):
	var player = player_scene.instantiate()
	player.name = str(id)
	
	
	# Set position
	var spawn_pos_id = randi_range(0, player_spawn_positions.size() - 1)
	player.global_position = player_spawn_positions[spawn_pos_id].global_position
	
	get_node(player_spawn_parent).call_deferred('add_child', player)


func _on_game_started():
	countdown_timer.start()


func get_time_remaining():
	return countdown_timer.time_left


func _on_start_game_pressed():
	GameManager.start_game()


@rpc("any_peer", "call_local", "reliable", 0)
func request_spawn(node):
	call_deferred("add_child", node)


func _on_hide_timer_timeout():
	if multiplayer.is_server():
		GameManager.on_game_countdown_ended.rpc()
