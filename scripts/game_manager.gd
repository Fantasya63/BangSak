extends Node

enum TEAM { Seeker, Hider }

var first_eliminated : int = 0
var seeker_won : bool = false
var is_first_game := true

var players : Dictionary = {
	# ID, #GameStat
}

#Debug
signal on_debug_rpc(sender: int)

var num_hiders : int 
var num_hiders_left : int

signal game_started
signal game_ended(winner : int)
signal on_player_eliminated(num_hider_left : int)

var _game_started_flag := false


func is_game_started() -> bool:
	return _game_started_flag


func get_team(playerID : int):
	var stat : Dictionary = players[playerID]
	return stat['team']


# TODO: Fix so that we are not passing a ref
# We should pass a value
@rpc("authority", "call_local", "reliable", 0)
func register_game(_players : Dictionary, _num_hider : int):
	_game_started_flag = true
	_countdown_ended = false
	players = _players
	num_hiders = _num_hider
	num_hiders_left = _num_hider
	game_started.emit()


func play_again_pressed():
	start_game()

var seekerID : int
func start_game():
	# Can only run by the server
	if not multiplayer.is_server():
		return
	
	# Get all the player keys
	var playerIDs = NetworkManager.players.keys()
	if playerIDs.size() <= 1:
		return
	
	# Only start the game if there are players
	if playerIDs.is_empty():
		return
	
	
	if is_first_game:
		seekerID = playerIDs.pick_random()
		is_first_game = false
	
	elif seeker_won:
		seekerID = first_eliminated
	
	first_eliminated = 0
	seeker_won = false
	#seekerID = 1
	
	num_hiders = playerIDs.size() - 1
	num_hiders_left = num_hiders
	
	# Assign the players into the container
	for playerID in playerIDs:
		# Create a game stat for the player
		var stat = {}
		stat['eliminated'] = false
		stat['team'] = 0 if playerID == seekerID else 1
		players[playerID] = stat

	register_game.rpc(players, num_hiders)

signal on_countdown_ended
var _countdown_ended := false
# RPC to clients to tell that the server's hide time has ended
@rpc("authority", "call_local", "reliable")
func on_game_countdown_ended():
	on_countdown_ended.emit()
	_countdown_ended = true


signal on_player_attacked(id : int)
# The server can only call and is executed in all players
@rpc("authority", "call_local", "reliable")
func _notify_player_attacked(playerID : int):
	var stats : Dictionary = players[playerID]
	
	# eliminate player
	if stats['eliminated'] == true:
		return
		
	stats['eliminated'] = true
	players[playerID] = stats
	
	#TODO: Refactor.  this is not working in other client
	var rem : int
	for id in players:
		if players[id]["team"] == 1 and players[id]['eliminated'] == false:
			rem += 1
	
	on_player_attacked.emit(playerID)
	
	if get_team(playerID) == TEAM.Seeker:
		# Seeker Eliminated:
		if multiplayer.is_server():
			seeker_won = false
			first_eliminated = 0
			
		game_ended.emit(1)
		
	else:
		# Hider Eliminated:
		num_hiders_left = rem
		if num_hiders_left <= 0:
			if multiplayer.is_server():
				seeker_won = true
		
			game_ended.emit(0)
			
				


# Anyone can call but only the server will execute
@rpc("any_peer","call_local", "reliable")
func attack_player(attack : Attack, id : int):
	if not _countdown_ended:
		return
	
	match attack.type:
		Attack.TYPE.Bang:
			var _team = get_team(id)
			if _team == 0:
				return
				
			if first_eliminated == 0:
				first_eliminated = id
			_notify_player_attacked.rpc(id)
		
		
		Attack.TYPE.Sak:
			var _team = get_team(id)
			if _team == 1:
				return
			_notify_player_attacked.rpc(id)
		
		
		Attack.TYPE.Stun:
			# TODO: Implement Stun
			pass


# Call on every peer
# WARNING! DO NOT SEND DATA THROUGH RPC
# IDK WHY BUT ITS NOT WORKING! Maybe its just sending the ref of it? 
@rpc("any_peer", "call_remote", "reliable")
func rpc_on_player_fire():
	var senderID = multiplayer.get_remote_sender_id()
	
	var player : Player = get_tree().root.get_node("Game").get_node(str(senderID))
	if player:
		player.rpc_fire()
	if OS.is_debug_build():
		on_debug_rpc.emit(multiplayer.get_remote_sender_id())
