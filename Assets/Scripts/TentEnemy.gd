extends Node

const enemy_player = preload("res://Assets/Scenes/EnemyPlayer.tscn")
var battleScene = load("res://Assets/Scenes/Battle.tscn")
var currentBattle
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
var attacker_team = null
var currentAttacker = null
var soldiers = []
var parentSquare
var attackTimer = Timer.new()
export var minDefendersToAttack = 1

var grid
# Called when the node enters the scene tree for the first time.
func _ready():
	parentSquare = get_parent().get_parent()
	add_child(attackTimer)
	attackTimer.wait_time = 1
	attackTimer.connect("timeout", self, "_tryAttack")
	attackTimer.start()

	
	connect("body_entered", self, "_on_body_entered")
	soldiers = get_parent().getSoldiers()
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
	
	if currentBattle == null:
		attacker_team = body.team
		currentAttacker = body
		currentBattle = battleScene.instance()
		add_child(currentBattle)
		attackTimer.stop()
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if getTeam() != 0 and currentBattle == null:
		if rng.randi_range(0, 10000) == 1:
			_attack()

func getTeam():
	return get_parent().ownerPlayerNumber

func _tryAttack():
	var x = len(soldiers)
	var a = 1.67
	var b = 5
	var c = -16.7
	if getTeam() != 0:
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

	var path = get_parent().get_parent().get_parent().findPath(enemyPlayer.global_position, closestTent.get_parent().global_position)
	
	enemyPlayer.travelPath(path)
	for soldier in soldiers:
		soldier.setTarget(enemyPlayer)
		enemyPlayer.followers.append(soldier)
		

	soldiers.clear()
	
	
func _getPlayerTents():
	var playerTents = []
	
	for member in get_tree().get_nodes_in_group("PlayerTents"):
		playerTents.append(member)
	
	return playerTents


func getCurrentAttacker():
	return currentAttacker


func getTargetableNode():
	return parentSquare
	

func takeDefendersFromTent():
	var defenders = []
	for soldier in soldiers:
		defenders.append(soldier)
	
	soldiers.clear()
	
	return defenders


func endBattle(winnerTeam, remainingTroops):
	currentBattle = null
	
	get_parent().setOwnership(winnerTeam)
	get_parent().addSoldiers(remainingTroops)
	
	attackTimer.start()
