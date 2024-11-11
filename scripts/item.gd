extends CharacterBody2D
@onready var anim : AnimatedSprite2D = $anim

func _ready(): 
	anim.play("default")
