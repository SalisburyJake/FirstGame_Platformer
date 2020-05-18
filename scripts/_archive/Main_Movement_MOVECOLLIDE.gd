extends KinematicBody2D

const WALK_SPEED = 400
const GRAVITY = 10
const JUMP_SPEED = 700
const MAX_SPEED = 500
const ACCELERATION = 100
const DECELERATION = 1000

var dir = 0
var inputDir = 0
var speed_x = 0
var speed_y = 0
var jump = false
var jumpReleased = false
var moving = false
onready var animation = get_node("AnimationPlayer")
onready var sprite = get_node("MainPlayer_Sprite")

func _ready():
	animation.connect("finished", self, "on_animationFinished")

func on_animationFinished():
	animation.stop
	
func _process(delta):
	if Input.is_action_just_pressed("right"):
		sprite.set_flip_h(false)
		animation.play("move")
	if Input.is_action_just_pressed("left"):
		sprite.set_flip_h(true)
		animation.play("move")
	if(    (Input.is_action_just_released("left"))\
		or (Input.is_action_just_released("right"))):
		animation.play_backwards("move")
		
#	if(Input.is_action_just_released("fire")):
#		fire()

func _physics_process(delta):

	#Left to Right Movement
	if Input.is_action_pressed("right"):
		inputDir = 1
	elif Input.is_action_pressed("left"):
		inputDir = -1
	else:
		inputDir = 0
		
	if inputDir:
		dir = inputDir
		speed_x += ACCELERATION
	else:
		speed_x -= DECELERATION
	
	speed_x = clamp(speed_x, 0, MAX_SPEED)
	
	if(is_on_floor()):
		speed_y = -15
	else:
		speed_y += GRAVITY
	
	
#	#Jump Movement
#	if Input.is_action_pressed("jump"):
#		jump = true
#	else:
#		jump = false
#	if Input.is_action_just_released("jump"):
#		jumpReleased = true
#	process_jump()
	var velocity = Vector2(speed_x * delta * dir, speed_y * delta)
	var collision = move_and_collide(velocity)

#func process_jump():
#	if(jumpReleased):
#		if velocity.y < 0:
#			velocity.y = 0
#		jumpReleased = false
#	if(jump):
#		if is_on_floor():
#			velocity.y = -JUMP_SPEED

#func fire():
#	var laser = LASER.instance()
