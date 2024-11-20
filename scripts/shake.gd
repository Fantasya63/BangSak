extends Camera2D

@export var random_magnitude : float = 30.0
@export var dur : float = 5.0

var rng = RandomNumberGenerator.new()

var shake_magnitude : float = 0.0

@onready var root = get_tree().root
var player_id = ""

# Called when the node enters the scene tree for the first time.
func apply_shake():
	shake_magnitude = random_magnitude
	
func _ready():
	var current_node = self  # This is where you are currently
	var player_node = current_node.get_parent() # Navigate to the player node
	player_id = str(player_node.name)
	print("ID : " + player_id)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if root.get_node("Game").get_node(player_id).eliminated:
		apply_shake()
	
	#if Input.is_action_just_pressed("fire"):
		#apply_shake()
		
	if shake_magnitude > 0:
		shake_magnitude = lerpf(shake_magnitude, 0, dur * delta)
		offset = random_offset()

func random_offset():
	return Vector2(rng.randf_range(-shake_magnitude, shake_magnitude), rng.randf_range(-shake_magnitude, shake_magnitude))
