extends Node

enum {Seeker, Hider}

var players : Dictionary = {
	# ID, #GameStat
}



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


@rpc("authority", "call_local", "reliable", 0)
func register_game(_players : Dictionary):
	_game_started_flag = true
	players = _players
	game_started.emit()


func start_game():
	# Can only run by the server
	if not multiplayer.is_server():
		return
	
	# Get all the player keys
	var playerIDs = NetworkManager.players.keys()
	
	# Only start the game if there are players
	if playerIDs.is_empty():
		return
	
	
	var seekerID = playerIDs.pick_random()
	#while seekerID == 1:
		#seekerID = playerIDs.pick_random()
		#
	seekerID = 1
	
	num_hiders = playerIDs.size() - 1
	num_hiders_left = num_hiders
	
	# Assign the players into the container
	for playerID in playerIDs:
		# Create a game stat for the player
		var stat = {}
		stat['eliminated'] = false
		stat['team'] = 0 if playerID == seekerID else 1
		players[playerID] = stat

	register_game.rpc(players)

#
#@rpc("any_peer", "call_local", "reliable")
#func notify_player_eliminattion(playerID : int):
	#if playerID == multiplayer.get_unique_id():
		#return
	#
	#players[playerID]['eliminated'] = true
	#var player = get_tree().root.get_node("Game").get_node(str(playerID))
	#player.eliminate()
	#
	#var rem : int
	#for id in players:
		#if players[id]["team"] == 1 and players[id]['eliminated'] == false:
			#rem += 1
	#
	#if get_team(playerID) == 0:
		## Seeker Eliminated:
		#game_ended.emit(1)
	#else:
		## Hider Eliminated:
		#num_hiders_left = rem
		#if num_hiders_left <= 0:
			#game_ended.emit(0)
	#
	#on_player_eliminated.emit(num_hiders_left)

#
## Server and Sender
#@rpc("any_peer", "call_local", "reliable")
#func eliminate(playerID : int):
	#var stats : Dictionary = players[playerID]
	#
	## eliminate player
	#if stats['eliminated'] == true:
		#return
		#
	#stats['eliminated'] = true
	#players[playerID] = stats
	#notify_player_eliminattion.rpc(playerID)
	#notify other players


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
	on_player_attacked.emit()
	
	var rem : int
	for id in players:
		if players[id]["team"] == 1 and players[id]['eliminated'] == false:
			rem += 1
	
	
	if get_team(playerID) == 0:
		# Seeker Eliminated:
		game_ended.emit(1)
	else:
		# Hider Eliminated:
		num_hiders_left = rem
		if num_hiders_left <= 0:
			game_ended.emit(0)
	
#
## The server can only call and is executed in all players
#func _anotify_player_attacked(playerID : int):
	#var stats : Dictionary = players[playerID]
	#
	## eliminate player
	#if stats['eliminated'] == true:
		#return
		#
	#stats['eliminated'] = true
	#players[playerID] = stats
	#on_player_attacked.emit()


# Anyone can call but only the server will execute
@rpc("any_peer","call_local", "reliable")
func attack_player(attack : Attack, id : int):
	
	
	match attack.type:
		0:
			var _team = get_team(id)
			if _team == 0:
				return
			_notify_player_attacked.rpc(id)
			
		1:
			var _team = get_team(id)
			if _team == 1:
				return
			_notify_player_attacked.rpc(id)

		2:
			pass


#
#func _attack_player(attack : Attack, id : int):
	#match attack:
		#Attack.Bang:
			#var _team = get_team(id)
			#if _team == 0:
				#return
			#NetworkManager._notify_player_attacked.rpc(id)
			#
		#Attack.Sak:
			#var _team = get_team(id)
			#if _team == 1:
				#return
			#NetworkManager._notify_player_attacked.rpc(id)
#
		#Attack.Stun:
			#pass

@rpc("any_peer", "call_local", "reliable")
func request_spawn(prefab : PackedScene, id : int, pos : Vector2, rot : float):
	var node = prefab.instantiate()
	node.global_rotation = rot
	node.global_position = pos
	node.set_multiplayer_authority(id)
	
	get_tree().root.get_node("Game").call_deferred("add_child", node)
