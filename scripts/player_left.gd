extends HBoxContainer

@onready var remaining_label : Label = $Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_started.connect(_on_game_started)
	GameManager.on_player_attacked.connect(_on_player_eliminated)
	
	visible = false

func _on_game_started():
	var remaining = GameManager.num_hiders_left
	var total = GameManager.num_hiders
	
	remaining_label.text = str(remaining) + "/" + str(total)
	visible = true

func _on_player_eliminated(playerID : int):
	var rem : int
	for id in GameManager.players:
		if GameManager.players[id]["team"] == GameManager.TEAM.Hider and GameManager.players[id]['eliminated'] == false:
			rem += 1
	
	remaining_label.text = str(rem) + "/" + str(GameManager.num_hiders)
	
