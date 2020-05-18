extends Node2D
#const enemy_scene = preload("res://scenes/enemy.tscn")
var placement = Vector2()
onready var enggoalNode = $endgoal

func _ready():
#	var enemy = enemy_scene.instance()
#	placement.x = 3500
#	placement.y = 500
#	enemy.position = placement
#	add_child(enemy)
	get_node("endgoal").connect("endLevel", self, "_endLevel") 
	pass

func _endLevel():
	var level = "res://scenes/levels/level_2.tscn"
	get_tree().change_scene(level)

#	# Add the next level
#	var next_level_resource = load("res://path/to/scene.tscn")
#	var next_level = next_level_resource.instance()
#	root.add_child(next_level)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	pass
