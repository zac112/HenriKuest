extends Node

const battle_symbol = preload("res://Assets/Scenes/UI/battle_symbol.tscn")
var battleSymbol
var defenders = []
var attackers = []
var battleTimer = Timer.new()
var tent
var attackingPlayer
var attackingPlayerTeam


# Called when the node enters the scene tree for the first time.
func _ready():
	_startBattle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
	
func _startBattle():
	tent = get_parent()
	attackingPlayer = tent.getCurrentAttacker()
	attackingPlayerTeam = attackingPlayer.getTeam()
	_takeDefendersFromTent()
	_takeSoldiersFromPlayer()
	_setUpBattleTimer()
	_setUpBattleSymbol()


func _setUpBattleTimer():
	add_child(battleTimer)
	battleTimer.wait_time = 1
	battleTimer.connect("timeout", self, "_simulateCombat")
	battleTimer.start()


func _setUpBattleSymbol():
	battleSymbol = battle_symbol.instance()
	add_child(battleSymbol)

# Ends combat if runs out of attackers or defenders, otherwise kills units
func _simulateCombat():	
	if defenders.size() == 0 || attackers.size() == 0:
		_endBattle()
	else:
		_killUnits()
	

# Kills one attacker and one defender
func _killUnits():
	defenders.pop_back().destroy()
	attackers.pop_back().destroy()


func _takeDefendersFromTent():
	defenders = tent.takeDefendersFromTent()
	
	
func _takeSoldiersFromPlayer():
	var newSoldiers = attackingPlayer.takeSoldiersFromPlayer()
	if tent.getTeam() == attackingPlayer.getTeam():
		_addDefenders(newSoldiers)
	else:
		_addAttackers(newSoldiers)


func _addDefenders(newDefenders):
	for defender in newDefenders:
		defenders.append(defender)


func _addAttackers(newAttackers):
	for attacker in newAttackers:
		attackers.append(attacker)
		attacker.setTarget(tent.getTargetableNode())
	
func _endBattle():
	battleTimer.stop()
	var winner = _checkWinner()
	tent.endBattle(winner[0], winner[1])
	
	if is_instance_valid(attackingPlayer):
		attackingPlayer.destroyIfNotHuman()
	self.queue_free()


func _checkWinner():	
	if defenders.size() == 0:
		return [attackingPlayerTeam, attackers]
	else:
		return [tent.getTeam(), defenders]
