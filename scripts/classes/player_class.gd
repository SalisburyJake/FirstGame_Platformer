extends Node	

class player_stats:
	var health
	var attackPower
	var invulnerable
	
	func _init(_startHealth, _startAttackPower):
		health = _startHealth
		attackPower = _startAttackPower
		invulnerable = false #start the player off as not invulnerable
		
	func getHealth():
		return self.health
	
	func addHealth(extraHealth):
		self.health += extraHealth
		
	func getAttackPower():
		return self.attackPower
		
	func setAttackPower(newAttackPower):
		self.attackPower = newAttackPower
		
	func getInvulnerable():
		return self.invulnerable
		
	func setInvulnerable(newInvulnerable):
		self.invulnerable = newInvulnerable
