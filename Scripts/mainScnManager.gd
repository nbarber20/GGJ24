extends Node
@export var bgAnim : AnimationPlayer
@export var bg : Sprite2D
@export var bgHappy : Texture2D
@export var bgAngry : Texture2D
@export var hammer : AnimatedSprite2D
@export var player : Node2D

func start():
	hammer.hide()

func updateBg():
	bg.texture = bgAngry

func lose():
	hammer.show()
	bgAnim.play("new_animation")
	hammer.play()
	var killTimer = get_tree().create_timer(0.45)
	await killTimer.timeout
	bg.texture = bgHappy
	player.hide()
