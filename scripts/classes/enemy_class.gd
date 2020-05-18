extends Node

class enemy_stats:
	var health
	var attackPower
	var maxPlayerDetectDist
	var moveSpeed
	
	func _init(_startHealth, _startAttackPower):
		health = _startHealth
		attackPower = _startAttackPower
		maxPlayerDetectDist = 400
		moveSpeed = 200
		
	func getHealth():
		return self.health
		
	func getAttackPower():
		return self.attackPower
		
	func getmaxPlayerDetectDist():
		return self.maxPlayerDetectDist
		
	func getMoveSpeed():
		return self.moveSpeed
