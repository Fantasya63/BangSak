extends CharacterBody2D
class_name Player

@export_color_no_alpha var eliminated_color : Color
@onready var anim : AnimatedSprite2D = $anim
@onready var footstep_audio_timer : Timer = $footstepTimer

@export_node_path("Label") var name_path
@onready var nametag : Label = get_node(name_path)

@onready var authority_id : int = name.to_int() 

@onready var footstep_audios = [
	$footstep/footstepAudio1,
	$footstep/footstepAudio2,
	$footstep/footstepAudio3,
	$footstep/footstepAudio4,
]

@onready var weapons = [
	$weapons/bang_holder/bang,
	$weapons/sak,
]
@onready var current_weapon : BaseWeapon = weapons[0]

@export var walk_speed := 75.0
@export var sprint_speed := 115.0
@export_range(0.0, 1.0) var anim_speed_scale := 0.01
@export var camera_prefab : PackedScene


enum TEAM { SEEKER, HIDER }
var team : TEAM

enum SPRITE_DIR { UP, DOWN, LEFT, RIGHT }
var sprite_dir : SPRITE_DIR = SPRITE_DIR.DOWN
var speed := 0.0
var player_info 
var eliminated := false
var gender : String
var cam : FollowCam
var win : bool

func get_cam() -> FollowCam:
	return cam


func _enter_tree():
	set_multiplayer_authority(name.to_int())
	NetworkManager.on_player_gender_reply.connect(_on_player_gender_reply)
	
func _on_player_gender_reply(gender_reply, id):
	if id == authority_id:
		gender = gender_reply
		
func _ready():
	#print("SHAKE : ", shake)
	GameManager.on_countdown_ended.connect(_server_on_countdown_ended)
	GameManager.on_player_attacked.connect(_on_player_attacked)
	GameManager.game_started.connect(_on_game_started)
	GameManager.game_ended.connect(_on_game_ended)
	$PlayerHitbox.playerID = name.to_int()
	NetworkManager.ask_player_gender.rpc_id(1, authority_id)
	
	anim.play("boy_down_idle")
	
	for weapon : BaseWeapon in weapons:
		weapon.disable()
		if not is_multiplayer_authority():
			weapon.hide_icons()
	
	if is_multiplayer_authority():
		cam = camera_prefab.instantiate()
		cam.name = "shake"
		add_child(cam)
	else:
		$sight_cast.visible = false
	
	
	team = 0 if authority_id == 1 else 1
	set_weapon()

	# Set weapon req
	$weapons/bang_holder/bang.player = self


func _on_game_ended(winner : int):
	if winner == team:
		win = true
		
# resets the playey to be ready to start another game
func reset():
	# Get team from manager
	win = false
	anim.play(gender + "_down_idle")
	team = GameManager.get_team(name.to_int())
	set_weapon()
	
	eliminated = false
	set_process_input(true)
	$CollisionShape2D.set_deferred("disabled", false)
	$PlayerHitbox/CollisionShape2D.set_deferred("disabled", false)
	anim.modulate = Color.WHITE


# called by the game manager when a player is attacked
func _on_player_attacked(id : int):
	if id == name.to_int():
		eliminate()


func _server_on_countdown_ended():
	if GameManager.get_team(name.to_int()) == 0:
		set_process_input(true)
		set_process_unhandled_input(true)
		set_process(true)
		set_physics_process(true)


# Called by the game manager when the game is started
func _on_game_started():
	reset()
	position = Vector2(0,0)
	
	if team == 0:
		set_process(false)
		set_physics_process(false)
		set_process_input(false)
		set_process_unhandled_input(false)
	
	# Disable nametag for other players
	# But only those who are not in our team
	# Those who are, we enable them
	if not is_multiplayer_authority():
		$nametag.visible = team == GameManager.get_team(get_tree().root.multiplayer.get_unique_id())


# Set the weapon to use with the set player team
# must set the team to desired value first before calling this
func set_weapon():
	# Disable current weapon if there is
	if current_weapon:
		current_weapon.disable()
	
	# Get new weapon and enable it
	current_weapon = weapons[team]
	current_weapon.enable()


func set_name_tag_with_name(_name: String):
	$nametag.text = _name
	

func set_name_tag():
	var _name = NetworkManager.players[name.to_int()]['name']
	
	print_debug(_name)
	if not _name:
		if OS.is_debug_build():
			breakpoint
		_name = "name"
		
	$nametag.text = _name

func _physics_process(delta):
	if GameManager.is_game_started():
		if GameManager.players[name.to_int()]['eliminated'] == true:
			if $shake and not eliminated:
				$shake.apply_shake()
			eliminate()
	
	if speed > 0.0:
		play_footstep()
	
	if is_multiplayer_authority():
		var move_input := Vector2.ZERO
		
		if Input.is_action_pressed("up"):
			sprite_dir = SPRITE_DIR.UP
			move_input.y -= 1
		
		if Input.is_action_pressed("down"):
			sprite_dir = SPRITE_DIR.DOWN
			move_input.y += 1
		
		if Input.is_action_pressed("left"):
			sprite_dir = SPRITE_DIR.LEFT
			move_input.x -= 1
		
		if Input.is_action_pressed("right"):
			sprite_dir = SPRITE_DIR.RIGHT
			move_input.x += 1
		
		# Normalize the values to avoid moving faster when moving in a diagonal
		move_input = move_input.normalized()
		
		# Set the players velocity
		if Input.is_action_pressed("sprint"):
			velocity = move_input * sprint_speed
		else:
			velocity = move_input * walk_speed
		
		move_and_slide()
	
	# Normal Anim
	play_anim()
	


func play_footstep():
	if footstep_audio_timer.time_left <= 0:
		var footstep_id = randi() % 4
		
		footstep_audios[footstep_id].pitch_scale = randf_range(0.8, 1.2)
		footstep_audios[footstep_id].play()
		footstep_audio_timer.start(0.25)


func play_anim():
	if is_multiplayer_authority():
		speed = velocity.length()
	
	if speed > 0.0:
		anim.speed_scale = speed * anim_speed_scale * 0.1
	else:
		anim.speed_scale = 1.0
		
	var dir : String = ""
	var movement : String = ""
	
	if not win:
		match sprite_dir:
			SPRITE_DIR.UP:
				# Dont flip the sprite
				anim.flip_h = false
				dir = "up"
				
			SPRITE_DIR.DOWN:
				# Dont flip the sprite
				anim.flip_h = false
				dir = "down"
				
			SPRITE_DIR.LEFT:
				# Dont flip the sprite
				anim.flip_h = true
				dir = "side"
			
			SPRITE_DIR.RIGHT:
				# Dont flip the sprite
				anim.flip_h = false
				dir = "side"
		
		if speed == 0:
			movement = "idle"
		else:
			movement = "walk"
			
		if not eliminated:
			anim.play(gender + "_" + dir + "_" + movement)
		else:
			anim.play(dir + "_eliminated")
	else:
		anim.play(gender + "_" +"victory")

		# TODO: REFACTOR TO INCLUDE ELIMINATED STATE IN PLAYING ANIM

# Disables all the weapons
func disable_weapons():
	for weapon : BaseWeapon in weapons:
		weapon.disable()


func _input(event):
	if OS.is_debug_build():
		if event.is_action_pressed("debug_rpc"):
			GameManager.rpc_debug.rpc()


func rpc_fire():
	current_weapon.rpc_apply_fire()
	print_debug("Debug RPC FIRE")


func eliminate():
	eliminated = true
	set_process_input(false)
	$CollisionShape2D.set_deferred("disabled", true)
	$PlayerHitbox/CollisionShape2D.set_deferred("disabled", true)
	#anim.modulate = eliminated_color
	#anim.play("eliminated")
	disable_weapons()
