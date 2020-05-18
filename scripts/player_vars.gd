extends Node

#onready var playerscript = preload("res://scripts/classes/player_class.gd")

#var player_stats = playerscript.player_stats.new(3,1)

var health
var maxHealth

func _ready():
	health = 3
	maxHealth = 5

func onDeath():
	health = 3
