extends Node

var defenders = []
var attackers = []
var battleTimer = Timer.new()
var tent
var attackingPlayer
var defendingPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	tent = get_parent()
	attackingPlayer = tent.getCurrentAttacker()
	defendingPlayer = tent.getCurrentOwner()
	_takeDefendersFromTent()
	_takeSoldiersFromPlayer()
	_setUpBattleTimer()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass


func _setUpBattleTimer():
	battleTimer.wait_time = 1
	add_child(battleTimer)
	battleTimer.connect("timeout", self, "_simulateCombat")


# Ends combat if runs out of attackers or defenders, otherwise kills units
func _simulateCombat():
	if defenders.size() == 0 || attackers.size() == 0:
		_endBattle()
	else:
		_killUnits()


# Kills one attacker and one defender
func _killUnits():
	defenders.pop_back().queue_free()
	attackers.pop_back().queue_free()


func _takeDefendersFromTent():
	var newDefenders = tent.getDefenders()
	
	for defender in newDefenders:
		defenders.append(defender)
	
	
func _takeSoldiersFromPlayer():
	pass


func _addDefenders(newDefenders):
	for defender in newDefenders:
		defenders.append(defender)


func _addAttackers(newAttackers):
	for attacker in newAttackers:
		attackers.append(attacker)
	
func _endBattle():
	#STUFF TO DO
	
	queue_free()
