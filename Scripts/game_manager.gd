extends Node

@export var sceneMain : PackedScene
@export var sceneMenu : PackedScene
@export var ball : PackedScene
@export var timerText : Label
@export var startingLives : int

var levelRef
var menuRef
var timer
var lives
var balls = []
var rng = RandomNumberGenerator.new()
var ballTimer
var lost = false

func _ready():
	startMenu()

func _process(delta):
	if lost:
		return
	
	if levelRef:
		timer += delta
		var time = timer
		var mins = int(time) / 60
		time -= mins * 60
		var secs = int(time)
		var mstr = str(mins) if mins > 10 else "0" + str(mins)
		var sstr = str(secs) if secs > 10 else "0" + str(secs)
		timerText.text = mstr + " : " + sstr
		
	for ball in balls:
		if ball.global_transform.origin.y > 260:
			dropBall()
			balls.erase(ball)

func spawnBall():
	rng.randomize()
	var newBall = ball.instantiate()
	var x = rng.randf_range(-300.0, 300.0)
	newBall.global_transform.origin = Vector2(x, -400)
	levelRef.add_child(newBall)
	balls.append(newBall)

func startBallTimer():
	ballTimer = get_tree().create_timer(balls.size() * 5)
	ballTimer.timeout.connect(onballtimer)

func onballtimer():
	if lost:
		return
	
	if levelRef:
		spawnBall()
	
	ballTimer.wait_time = balls.size() * 5.0
	ballTimer.start()

func dropBall():
	lives -= 1
	if lives <= 0:
		die()
	if lives <= startingLives * 0.5 and levelRef:
		levelRef.updateBg()

func die():
	for ball in balls:
		ball.queue_free()
		
	lost = true
	levelRef.lose()
	var loseTimer = get_tree().create_timer(2)
	await loseTimer.timeout
	restartGame()

func restartGame():
	ballTimer = null
	if levelRef:
		levelRef.queue_free()
		levelRef = null
	
	if menuRef:
		menuRef.queue_free()
		menuRef = null
	
	balls.clear()
	startMenu()	
	
func startMenu():
	timerText.hide()
	menuRef = sceneMenu.instantiate()
	add_child(menuRef)

func startGame():
	if menuRef:
		menuRef.queue_free()
		menuRef = null
	
		levelRef = sceneMain.instantiate()
		add_child(levelRef)
		levelRef.start()
		
		lives = startingLives
		timer = 0.0
		timerText.show()
		
		spawnBall()
		
		ballTimer = Timer.new()
		add_child(ballTimer)
		ballTimer.one_shot = true
		ballTimer.timeout.connect(onballtimer)
		
		ballTimer.wait_time = balls.size() * 5.0
		ballTimer.start()
		lost = false

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			startGame()
