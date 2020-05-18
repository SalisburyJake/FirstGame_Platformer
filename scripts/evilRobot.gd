extends KinematicBody2D

enum{MOVING, STOPPED}

const FLOOR = Vector2(0, -1)
const GRAVITY = 2000

onready var enemyClassScript = preload("res://scripts/classes/enemy_class.gd")
onready var PlayerNode = get_tree().get_nodes_in_group("player")[0]
onready var sprite = $Sprite
onready var animation = $AnimationPlayer
onready var GroundDetectorLeft = $GroundDetectorLeft
onready var GroundDetectorRight = $GroundDetectorRight
var velocity = Vector2()
var enemystats
var movDir = 0
var isMoving = STOPPED

# Called when the node enters the scene tree for the first time.
func _ready():
	enemystats = enemyClassScript.enemy_stats.new(1,1)

func _process(_delta):
	processAnimation(velocity)

func _physics_process(delta):
	processMovement(delta)
	processPlayerCollision()

				
func processAnimation(vel):
	if ((vel.x > 0) && (movDir != 1)):
		sprite.set_flip_h(false)
		animation.play("move")
		movDir = 1
	elif ((vel.x < 0) && (movDir != -1)):
		sprite.set_flip_h(true)
		animation.play("move")
		movDir = -1
	else:
		movDir = 0
		
func processMovement(delta):
	var distToPlayer = self.get_global_transform().origin.distance_to(PlayerNode.get_global_transform().origin)
	if(distToPlayer < enemystats.getmaxPlayerDetectDist()):
		var dir = (PlayerNode.global_position - global_position).normalized()
		velocity.x = dir.x * enemystats.getMoveSpeed()
	
	if ((not GroundDetectorLeft.is_colliding()) and (velocity.x < 0)):
		velocity.x = 0
	if ((not GroundDetectorRight.is_colliding()) and (velocity.x > 0)):
		velocity.x = 0
	velocity.y += delta * GRAVITY	
	velocity = move_and_slide(velocity, FLOOR)

func processPlayerCollision():
	var numCollisions = get_slide_count()
	if(numCollisions > 0):
		for i in numCollisions:
			var collision = get_slide_collision(i)
			var collider = collision.collider
			if collider.is_in_group("player"):
				PlayerNode.takeDamage(enemystats.getAttackPower())
