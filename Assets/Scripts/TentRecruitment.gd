extends Node

const battle_symbol = preload("res://Assets/Scenes/battle_symbol.tscn")
var symbol

# Declare member variables here. Examples:
var recruitable = false
var player
var attackingPlayers = []

var combat = false
var attackers
var defenders = []
var battleTimer = Timer.new()
var parentSquare
var attackerID = 0
var symbolShowing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	parentSquare = get_parent().get_parent()
	defenders = get_parent().getSoldiers()
	add_child(battleTimer)
	battleTimer.wait_time = 1
	battleTimer.connect("timeout", self, "_killTroops")
	
	symbol = battle_symbol.instance()

func _on_body_entered(body:Node):		
	if body.is_in_group("Player"):
		player = body
		recruitable = true

func _on_body_exited(body:Node):
	if body.is_in_group("Player"):
		recruitable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkInput()
	if (combat == true && battleTimer.is_stopped()):
		symbolShowing = true
		get_parent().add_child(symbol)
		battleTimer.start()		
		
	if (combat == false and symbolShowing):
		symbolShowing = false
		get_parent().remove_child(symbol)

func _checkInput():
	if Input.is_action_just_pressed("command_troops") && recruitable:
		_recruitSoldiers()


func _recruitSoldiers():
	var soldiers = get_parent().getSoldiers()
	
	for soldier in soldiers:
		soldier.setTarget(player)
		player.getFollowers().append(soldier)
		soldier.modulate = Color(10, 1, 1)
	
	soldiers.clear()
	get_parent().resetTimer()

func _getAttackersFromPlayer(attackingPlayer):
	var playerSoldiers = attackingPlayer.getFollowers()
	var tempCopy = playerSoldiers.duplicate()
	attackers = []
	for soldier in tempCopy:
		attackers.append(soldier)
		soldier.setTarget(parentSquare)
	playerSoldiers.clear()


func _killTroops():
	if attackers == null:
		return
		
	print("Killed troops; defenders ",defenders.size(), " attaker ",attackers.size(), "")
	if defenders.size() == 0:
		var tempAttackers = attackers.duplicate()
		var newTent = get_parent().setOwnership(attackerID)
		newTent.addSoldiers(tempAttackers)
		combat = false
		for attackingP in attackingPlayers:
			if is_instance_valid(attackingP):
				attackingP.queue_free()
		attackers = null
		return
	
	if attackers.size() == 0 || defenders.size() == 0:
		combat = false
		for attackingP in attackingPlayers:
			if is_instance_valid(attackingP):
				attackingP.queue_free()
		attackers = null
	else:
		attackers.pop_back().queue_free()
		defenders.pop_back().queue_free()
		
