extends Node

const battle_symbol = preload("res://Assets/Scenes/battle_symbol.tscn")
var symbol
# Declare member variables here. Examples:
var player
var combat = false
var attackers = []
var defenders = []
var battleTimer = Timer.new()
var parentSquare
export var minDefendersToAttack = 2
var attackerID
export var AIavatar = preload("res://Assets/Scenes/PlayerAI.tscn")
var symbolShowing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	attackerID = get_parent().ownerPlayerNumber
	parentSquare = get_parent().get_parent()
	defenders = get_parent().getSoldiers()
	add_child(battleTimer)
	battleTimer.wait_time = 1
	battleTimer.connect("timeout", self, "_killTroops")
	connect("body_entered", self, "_on_body_entered")
	#connect("body_exited", self, "_on_body_exited")

	connect("body_exited", self, "_on_body_exited")
	symbol = battle_symbol.instance()
	
func _on_body_entered(body:Node):
	if body.is_in_group("AIPlayer"):
		get_parent().addSoldiers(body.getFollowers())
		body.queue_free()
		
	if body.is_in_group("Player"):
		player = body
		combat = true
		_getAttackersFromPlayer()

func _on_body_exited(body:Node):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (combat == true && battleTimer.is_stopped()):
		symbolShowing = true
		get_parent().add_child(symbol)
		battleTimer.start()
		
	if combat == false && defenders.size() >= minDefendersToAttack:
		_attack()
		
		
	if (combat == false and symbolShowing):
		symbolShowing = false
		get_parent().remove_child(symbol)
		

	

func _attack():
	var playerTents = _getPlayerTents()
	
	if playerTents.size() == 0:
		return
	
	var closestTent = null
	
	#print(closestTent.get_parent().position.distance_to(parentSquare.position))
	
	for tent in playerTents:
		if tent.isInCombat(): continue
		if closestTent == null: closestTent = tent
		if tent.get_parent().position.distance_to(parentSquare.position) < closestTent.get_parent().position.distance_to(parentSquare.position):
			closestTent = tent
	
	#No available tents; skip attack
	if closestTent == null: return
	
	var aiPlayer = AIavatar.instance()
	get_node("/root/Main Node").add_child(aiPlayer)
	aiPlayer.global_position = parentSquare.global_position
	
	var path = get_node("/root/Main Node/GridManager").findPath(aiPlayer.global_position, closestTent.get_parent().global_position)
	aiPlayer.travelPath(path)
	aiPlayer.setAttackerID(attackerID)
	
	for defender in defenders:
		aiPlayer.getFollowers().append(defender)
		defender.setTarget(aiPlayer)
	
	defenders.clear()
	
	

func _getPlayerTents():
	var playerTents = []
	
	for member in get_tree().get_nodes_in_group("PlayerTents"):
		playerTents.append(member)
	
	return playerTents

func _getAttackersFromPlayer():
	var playerSoldiers = player.getFollowers()
	var tempCopy = playerSoldiers.duplicate()
	for soldier in tempCopy:
		attackers.append(soldier)
		soldier.setTarget(parentSquare)
		playerSoldiers.clear()


func _killTroops():
	if attackers == null:
		return
		
	if defenders.size() == 0:
		var tempAttackers = attackers.duplicate()
		var newTent = get_parent().setOwnership(0)
		newTent.addSoldiers(tempAttackers)
		combat = false
		return
	
	if attackers.size() == 0 || defenders.size() == 0:
		combat = false
		battleTimer.stop()
	else:
		attackers.pop_back().queue_free()
		defenders.pop_back().queue_free()
		
