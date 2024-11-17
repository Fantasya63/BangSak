extends HBoxContainer

@onready var remaining_label : Label = $Label2

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.game_started.connect(_on_game_started)
	GameManager.on_player_eliminated.connect(_on_player_eliminated)
	
	visible = false

func _on_game_started():
	var remaining = GameManager.num_hiders_left
	var total = GameManager.num_hiders
	
	remaining_label.text = str(remaining) + "/" + str(total)
	visible = true

func _on_player_eliminated():
	var remaining = GameManager.num_hiders_left
	var total = GameManager.num_hiders
	
	remaining_label.text = str(remaining) + "/" + str(total)
	
