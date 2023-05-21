extends Node

const battle_symbol = preload("res://Assets/Scenes/battle_symbol.tscn")
const enemy_player = preload("res://Assets/Scenes/EnemyPlayer.tscn")
var symbol
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
var attacker_team = null
var combat = false
var attackers = []
var defenders = []
var attackTimer = Timer.new()
var battleTimer = Timer.new()
var parentSquare
export var minDefendersToAttack = 1
var symbolShowing = false

var grid
# Called when the node enters the scene tree for the first time.
func _ready():
	parentSquare = get_parent().get_parent()
	add_child(attackTimer)
	attackTimer.wait_time = 1
	attackTimer.connect("timeout", self, "_tryAttack")
	attackTimer.start()
	add_child(battleTimer)
	battleTimer.wait_time = 1
	battleTimer.connect("timeout", self, "_killTroops")
	
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	symbol = battle_symbol.instance()
	defenders = get_parent().getSoldiers()
	grid = get_tree().current_scene.get_node("GridManager")
	rng.randomize()
	
func _on_body_entered(body:Node):
	if !body.is_in_group("Bishop"): return		
	if !body.is_in_group("Player") and get_parent()==body.homenode: return
	
	#own village
	if (body.team == getTeam()):
		if (body.team != 0):
			get_parent().addSoldiers(body.getFollowers())
			body.queue_free()
		return
	#only one team can attack a tent at the same time
	if (attacker_team != null and attacker_team != body.team):
		return
	attacker_team = body.team
	combat = true
	defenders = get_parent().getSoldiers()
	_getAttackersFromPlayer(body)



func _on_body_exited(body:Node):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (combat == true && battleTimer.is_stopped()):
		print("Battle started " + str(getTeam()) + " attacked by " + str(attacker_team))
		print("Defenders size: " + str(defenders.size()))
		print("Attackers size: " + str(attackers.size()))
		battleTimer.start()
		symbolShowing = true
		get_parent().add_child(symbol)
	if (combat == false and symbolShowing):
		symbolShowing = false
		get_parent().remove_child(symbol)
		

		
func getTeam():
	return get_parent().ownerPlayerNumber

func _tryAttack():
	var x = len(defenders)
	var a = 1.67
	var b = 5
	var c = -16.7
	if getTeam() != 0 and combat == false:
		if rng.randi_range(0, 100) < a*x*x + b*x + c:
			_attack()
			
func _attack():
	print("attack ")
	var playerTents = _getPlayerTents()
	
	if playerTents.size() == 0:
		return
	
	var closestTent = null
	for tent in playerTents:
		if tent.isInCombat(): continue
		if closestTent == null: closestTent = tent
		if tent.get_parent().position.distance_to(parentSquare.position) < closestTent.get_parent().position.distance_to(parentSquare.position):
			closestTent = tent
	#No available tents; skip attack
	if closestTent == null: return

	var enemyPlayer = enemy_player.instance()
	enemyPlayer.setTeam(getTeam())
	enemyPlayer.setHome(get_parent())
	enemyPlayer.position = parentSquare.position
	grid.add_child(enemyPlayer)
	
	var path = get_node("/root/Main Node/GridManager").findPath(enemyPlayer.global_position, closestTent.get_parent().global_position)
	enemyPlayer.travelPath(path)
	for defender in defenders:
		defender.setTarget(enemyPlayer)
		enemyPlayer.followers.append(defender)
		

	defenders.clear()
	
	

func _getPlayerTents():
	var playerTents = []
	
	for member in get_tree().get_nodes_in_group("PlayerTents"):
		playerTents.append(member)
	
	return playerTents

func _getAttackersFromPlayer(player):
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
		var newTent = get_parent().setOwnership(attacker_team)
		newTent.addSoldiers(tempAttackers)
		combat = false
		return
	
	if attackers.size() == 0:
		combat = false
		battleTimer.stop()
		attacker_team = null
	else:
		attackers.pop_back().queue_free()
		defenders.pop_back().queue_free()
		
