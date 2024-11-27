extends Node

@export_node_path("Popup") var join_popup_path
@export_node_path("Popup") var account_popup_path 

@onready var join_popup = get_node(join_popup_path)
@onready var account_popup : AccountPopup = get_node(account_popup_path)
@onready var how_to_play_popup : TutorialPopup = $Control/tutorial_popup

func _on_create_btn_pressed():
	NetworkManager.create_game()
	NetworkManager.load_game("res://scenes/game_scene.tscn")

func _on_join_btn_pressed():
	join_popup.visible = true
	


func _on_exit_btn_pressed():
	get_tree().quit()


func _on_account_btn_pressed():
	var username = NetworkManager.player_info["name"]
	account_popup.set_username_text(username)
	account_popup.visible = true


func _on_how_to_play_pressed():
	how_to_play_popup.visible = true
