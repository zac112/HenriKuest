extends Node


# Declare member variables here. Examples:
var defenders = []
var attackers = []
var battleTimer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


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
	pass
	
	
func _getAttackers():
	pass
	
	
func _endBattle():
	pass
