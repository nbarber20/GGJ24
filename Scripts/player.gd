extends Node2D

@export var m1 : Texture2D
@export var m2 : Texture2D
@export var m3 : Texture2D

@export var Mouth : Sprite2D
@export var Rotator : Node2D
@export var LEye : Node2D
@export var REye : Node2D
@export var LHand : Node2D
@export var RHand : Node2D
@export var LFoot : Node2D
@export var RFoot : Node2D
@export var Wheel : Node2D
@export var MoveSpeed : float
@export var WheelSpeed : float

@export var MaxX : float
@export var Lean : float
@export var EyeRadius : float
@export var expressionThreshold : float

var LEyeCenter : Vector2
var REyeCenter : Vector2

func _ready():
	Mouth.texture = m1
	LEyeCenter = LEye.position
	REyeCenter = REye.position
	pass

func _process(delta):
	var target = (LHand.position + RHand.position) * 0.5
	var move = position.lerp(Vector2(target.x,0), delta * MoveSpeed)
	
	if move.x > 0:
		if move.x > MaxX:
			move.x = MaxX
	elif move.x < -MaxX:
		move.x = -MaxX
	
	
	var moveDelta = -(position - move).x
	position = move
	
	Rotator.rotation = min(Lean * moveDelta, 25)
	
	Wheel.rotate(moveDelta * WheelSpeed)
	LFoot.global_rotation = 0
	RFoot.global_rotation = 0
	
	'''TODO
	if moveDelta >= expressionThreshold:
		Mouth.texture = m2
	else:
		Mouth.texture = m1
	'''
	var lDir = get_global_mouse_position() - LEye.global_position
	LEye.position = LEyeCenter + (lDir.normalized() * EyeRadius)
	
	var rDir = get_global_mouse_position() - REye.global_position
	REye.position = REyeCenter + (rDir.normalized() * EyeRadius)
