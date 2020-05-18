extends Area2D

signal endLevel

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "body_entered")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func body_entered(body):
	if(body.name == "player"):
		emit_signal("endLevel")
