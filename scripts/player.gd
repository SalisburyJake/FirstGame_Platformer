extends KinematicBody2D

const MOVE_SPEED = 400
const GRAVITY = 2000
const JUMP_SPEED = 700
const FLOOR = Vector2(0, -1)
const MAXJUMPNUM = 2

enum movement{NONE, LEFT, RIGHT}

var moving = false
var velocity = Vector2()
onready var animation = $AnimationPlayer #get_node("AnimationPlayer")
onready var sprite = $Sprite #get_node("MainPlayer_Sprite")
onready var healthTag = $health_tag #get_node("health_tag")
onready var wallDetectorLeftTop = $WallDetector_Left/WallDetector_LeftTop
onready var wallDetectorLeftBottom = $WallDetector_Left/WallDetector_LeftBottom
onready var wallDetectorRightTop = $WallDetector_Right/WallDetector_RightTop
onready var wallDetectorRightBottom = $WallDetector_Right/WallDetector_RightBottom
var invulnerabilityTimer
var invulnerable #If the player is currently invulnerable
var invulnerableTime = 2 #seconds
var jumpNum = 0


func _ready():
	animation.connect("finished", self, "on_animationFinished")

	#Invulnerability timer when the player gets hurt
	invulnerabilityTimer = Timer.new()
	invulnerabilityTimer.set_wait_time(invulnerableTime)
	invulnerabilityTimer.connect("timeout",self,"_invulnerabilityTimerTimeout") 
	add_child(invulnerabilityTimer)

func on_animationFinished():
	animation.play("stop")
	
func _process(_delta):
	
	processCollision()	
	processAnimation()

	#Process damage taken from last cycle
	if(player_vars.health <= 0):
		death()
		
	healthTag.text = str("Health = ", player_vars.health)
	if(position.y > 1000):
		death()

func _physics_process(delta):	
	processMovement(delta)
	
	if(Input.is_action_just_released("attack")):
		attack()

func processMovement(delta):
	#Process horizontal movement first
	if Input.is_action_pressed("left"):
		velocity.x = -MOVE_SPEED
	elif Input.is_action_pressed("right"):
		velocity.x =  MOVE_SPEED
	else:
		velocity.x = 0
	
	#Process vertical movement next
	#Jump Input
	processJump()
	#Then add gravity
	velocity.y += delta * GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

func processAnimation():
	if Input.is_action_just_pressed("right"):
		sprite.set_flip_h(false)
		animation.play("move")
	if Input.is_action_just_pressed("left"):
		sprite.set_flip_h(true)
		animation.play("move")
	if(    (Input.is_action_just_released("left"))\
		or (Input.is_action_just_released("right"))):
		animation.play_backwards("move")
		
func processCollision():
	var takeDamage_b= false
	var damage = 0
	var numCollisions = get_slide_count()
	if(numCollisions > 0):
		for i in numCollisions:
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if collider.is_in_group("enemy"):
				takeDamage_b = true
				damage = collider.enemystats.getAttackPower()
	if(takeDamage_b):
		takeDamage_b = false
		takeDamage(damage)
		
func getWallJumpEnabled():
	var wallDetected = false
	var wallJumpEnabled
	
	#Check and see if we are detecting a wall
	if(wallDetectorLeftTop.is_colliding() or 
	wallDetectorLeftBottom.is_colliding() or
	wallDetectorRightTop.is_colliding() or
	wallDetectorRightBottom.is_colliding()):
		wallDetected = true
	else:
		wallDetected = false
	#If we are on a wall and not touching the ground, enable wall jump
	if ((wallDetected) and not is_on_floor()):
		wallJumpEnabled = true
	else:
		wallJumpEnabled = false
		
	return wallJumpEnabled

func processJump():
	var jump
	var jumpReleased
	var wallJumpEnabled
	var prevWallJumpEnabled
	
	#See if we are on a wall and that we have the ability to perform a wall jump
	wallJumpEnabled = getWallJumpEnabled()
	
	#First check inputs from jump, both pressed and JUST released
	if Input.is_action_just_pressed("jump"):
		jump = true
	else:
		jump = false
	if Input.is_action_just_released("jump"):
		jumpReleased = true
	
	#Next set the jump num to zero if we are on the floor or JUST entered wall jump
	if(is_on_floor() or ((wallJumpEnabled) and (not prevWallJumpEnabled))):
		jumpNum = 0
	#If jump button is pressed, jump
	if(jump):
		if(jumpNum < MAXJUMPNUM):
			velocity.y += -JUMP_SPEED
			jumpNum = jumpNum + 1
	#If we JUST released the jump button, don't update the Y velocity (or update to zero)
	if(jumpReleased):
		if velocity.y < 0:
			velocity.y = 0
		jumpReleased = false

	prevWallJumpEnabled = wallJumpEnabled
		
func attack():
	#animation.play("attack")
	pass

func takeDamage(amount):
	if(!invulnerable):
		player_vars.health -= amount
		invulnerable = 1
		invulnerabilityTimer.start()
	

func death():
# warning-ignore:return_value_discarded
	get_tree().reload_current_scene()
	player_vars.onDeath()
	
func _invulnerabilityTimerTimeout():
   invulnerable = 0
