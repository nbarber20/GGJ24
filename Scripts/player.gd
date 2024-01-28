extends Node2D

@export var LHand : Node2D
@export var RHand : Node2D
@export var LFoot : Node2D
@export var RFoot : Node2D
@export var Wheel : Node2D
@export var MoveSpeed : float
@export var WheelSpeed : float

func _ready():
	pass

func _process(delta):
	var target = (LHand.position + RHand.position) * 0.5
	var move = position.lerp(Vector2(target.x,0), delta * MoveSpeed)
	var moveDelta = -(position - move).x
	position = move
	
	Wheel.rotate(moveDelta * WheelSpeed)
	LFoot.global_rotation = 0
	RFoot.global_rotation = 0
