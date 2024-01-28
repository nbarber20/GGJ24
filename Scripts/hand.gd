extends Sprite2D

@export var OffsetDir : float
@export var Body : Node2D
@export var Radius : float
@export var HeightLimit : float

@export var ReturnSpeed : float
@export var MouseMoveSpeed : float
@export var ThrowSpeed : float

var Selected : bool
var HeldBall : RigidBody2D
var HandVelocity : Vector2

func _ready():
	Selected = false

func _process(delta):
	var targetPos = global_position
	var speed = MouseMoveSpeed
	
	if Selected:
		speed = MouseMoveSpeed
		targetPos = get_global_mouse_position()
	else:
		speed = ReturnSpeed
		var dir = Body.global_position + Vector2(OffsetDir,0.0) - global_position	
		if dir.length() > Radius:
			targetPos = Vector2(Body.global_position.x + OffsetDir, Body.global_position.y)
	
	global_position = global_position.lerp(targetPos, delta * speed)
	
	if global_position.y > Body.global_position.y + HeightLimit:
		global_position.y = Body.global_position.y + HeightLimit
	if global_position.y < Body.global_position.y - HeightLimit:
		global_position.y = Body.global_position.y - HeightLimit
	
	if OffsetDir > 0:
		if global_position.x < Body.global_position.x + (OffsetDir * 0.5):
			global_position.x = Body.global_position.x + (OffsetDir * 0.5)
	elif global_position.x > Body.global_position.x + (OffsetDir * 0.5):
			global_position.x = Body.global_position.x + (OffsetDir * 0.5)
			
	if HeldBall:
		HeldBall.global_transform.origin = global_position
		
func throw():
	if HeldBall:
		HeldBall.sleeping = false
		HeldBall.linear_velocity.y = 0
		
		var dir = Vector2.UP + Vector2(-OffsetDir * 0.01,0)
		HeldBall.apply_impulse(dir * ThrowSpeed)
		HeldBall.set_collision_layer(2)
		HeldBall = null

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if OffsetDir > 0:
				if get_global_mouse_position().x > Body.position.x:
					Selected = true
			else:
				if get_global_mouse_position().x < Body.position.x:
					Selected = true
		elif event.is_released():
			Selected = false
			throw()

func _on_area_2d_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	var layer = body.get_collision_layer()
	if(layer == 2):
		if body.linear_velocity.y > 10:
			if Selected:
				if HeldBall:
					var dir = Vector2.UP + Vector2(-OffsetDir * 0.01,0)
					body.apply_impulse(dir * ThrowSpeed)
					body.set_collision_layer(2)
				else:
					HeldBall = body
					HeldBall.sleeping = true
					HeldBall.set_collision_layer(0)
					HeldBall.global_transform.origin = global_position
			else:
					var dir = Vector2.UP + Vector2(-OffsetDir * 0.01,0)
					body.apply_impulse(dir * ThrowSpeed)
					body.set_collision_layer(2)
