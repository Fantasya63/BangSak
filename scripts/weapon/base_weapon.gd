extends Node2D
class_name BaseWeapon


@export_node_path("Node2D") var fire_point_path
@onready var fire_point : Node2D = get_node(fire_point_path)
@onready var cooldown_timer : Timer = $cooldown_timer
@onready var fire_sfx : AudioStreamPlayer2D = $fire_sfx

@export_node_path("Node2D") var icon_path
@onready var icon : Node2D = get_node(icon_path)

func _ready():
	if not is_multiplayer_authority():
		set_process(false)
		set_process_input(false)


# called when the server notified us that the player has fired
func rpc_apply_fire():
	pass


func hide_icons():
	icon.visible = false
	

func show_icons():
	icon.visible = true



# called locally by the player when the fire button is pressed
func fire():
	GameManager.rpc_on_player_fire.rpc()


func enable():
	visible = true
	set_process(true)
	set_process_input(true)
	set_process_unhandled_input(false)


func disable():
	visible = false
	set_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)
