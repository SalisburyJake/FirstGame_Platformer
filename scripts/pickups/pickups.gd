extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("area_entered", self, "area_entered")
	connect("body_entered", self, "body_entered")

func area_entered(area):
	print("hello")
	pass
