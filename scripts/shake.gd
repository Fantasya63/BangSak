extends Camera2D
class_name FollowCam

@export var random_magnitude : float = 16.0
@export var decay : float = 5.0
var current_decay : float

var rng = RandomNumberGenerator.new()

var shake_magnitude : float = 0.0


# Called when the node enters the scene tree for the first time.
func apply_shake(_magnitude = random_magnitude, _decay = decay):
	shake_magnitude = _magnitude
	current_decay = _decay


func _ready():
	current_decay = decay
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shake_magnitude > 0:
		shake_magnitude = lerpf(shake_magnitude, 0, current_decay * delta)
		offset = random_offset()


func random_offset():
	return Vector2(rng.randf_range(-shake_magnitude, shake_magnitude), rng.randf_range(-shake_magnitude, shake_magnitude))
