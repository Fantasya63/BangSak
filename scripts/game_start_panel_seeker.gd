extends Panel


@onready var timer = $"../../hide_timer"

@onready var role_label : Label = $role_text
@onready var info_label : Label = $info

var begin_countdown : bool = false
var role_text : String
var info_text : String

# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	GameManager.game_started.connect(_on_game_started)


func _on_game_started():
	begin_countdown = true
	# Get user role
	var playerID = multiplayer.get_unique_id()
	
	var team = GameManager.get_team(playerID)
	
	
	if team == 0:
		#Seeker
		role_text = "You are a Seeker."
		info_text = "Please wait %02d seconds for others to hide."
	else:
		# Hider
		role_text = "You are a Hider."
		info_text = "You have %02d seconds to hide."
	
	role_label.text = role_text
	info_label.text = info_text % timer.time_left
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not begin_countdown:
		return
	
	info_label.text = info_text % timer.time_left
	
	
	


func _on_hide_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.5)
