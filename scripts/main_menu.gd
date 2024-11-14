extends Node

@export_node_path("Popup")
var join_popup_path

@onready var join_popup = get_node(join_popup_path)

func _on_create_btn_pressed():
	pass # Replace with function body.


func _on_join_btn_pressed():
	join_popup.visible = true
	pass # Replace with function body.


func _on_exit_btn_pressed():
	get_tree().quit()
