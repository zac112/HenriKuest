extends Node


# Declare member variables here. Examples:
var defenders = []
var attackers = []
var battleTimer = Timer.new()
var tent
var attackingPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	tent = get_parent()
	attackingPlayer = tent.getCurrentAttacker()
	_getDefenders()
	_getAttackers()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_simulateCombat()


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


func _getDefenders():
	var newDefenders = tent.getDefenders()
	
	for defender in newDefenders:
		defenders.append(defender)
	
	
func _getAttackers():
	var newAttackers = attackingPlayer.getAttackers()
	
	for attacker in newAttackers:
		attackers.append(attacker)
	
	
func _endBattle():
	pass
