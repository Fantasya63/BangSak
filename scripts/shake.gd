extends Camera2D

@export var random_magnitude : float = 30.0
@export var dur : float = 5.0

var rng = RandomNumberGenerator.new()

var shake_magnitude : float = 0.0

# Called when the node enters the scene tree for the first time.
func apply_shake():
	shake_magnitude = random_magnitude
	
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_magnitude > 0:
		shake_magnitude = lerpf(shake_magnitude, 0, dur * delta)
		offset = random_offset()

func random_offset():
	return Vector2(rng.randf_range(-shake_magnitude, shake_magnitude), rng.randf_range(-shake_magnitude, shake_magnitude))
