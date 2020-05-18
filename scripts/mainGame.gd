extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var level = "res://scenes/levels/level_1.tscn"
	get_tree().change_scene(level)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
