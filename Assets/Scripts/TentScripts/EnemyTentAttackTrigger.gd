extends Node

const enemy_player = preload("res://Assets/Scenes/Characters/EnemyPlayer.tscn")
var rng = RandomNumberGenerator.new()
var parentSquare
var parentTent
var attackTimer = Timer.new()

var grid
# Called when the node enters the scene tree for the first time.
func _ready():
	parentTent = get_parent()
	parentSquare = get_parent().get_parent()
	add_child(attackTimer)
	attackTimer.wait_time = 2
	attackTimer.connect("timeout", self, "_tryAttack")
	attackTimer.start()
	
	grid = get_tree().current_scene.get_node("GridManager")
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(_delta):
#	pass

func getTeam():
	return get_parent().getOwnerTeamNumber()

func _tryAttack():
	var x = get_parent().getNumberOfSoldiers()
	var a = 1.67
	var b = 5
	var c = -16.7
	if getTeam() != 0 and parentTent.isInCombat() == false:
		if rng.randi_range(0, 100) < a*x*x + b*x + c:
			_attack()
			
func _attack():
	var closestTent = _findClosestTentViableForAttack()
	#No available tents; skip attack
	if closestTent == null: return
	
	var enemyBishop = _createEnemyBishop(closestTent)
	_moveSoldiersFromTentToBishop(enemyBishop)


func _findClosestTentViableForAttack():
	var playerTents = _getPlayerTents()
	var closestTent = null
	
	for tent in playerTents:
		if tent.isInCombat(): continue
		if closestTent == null: closestTent = tent
		if tent.get_parent().position.distance_to(parentSquare.position) < closestTent.get_parent().position.distance_to(parentSquare.position):
			closestTent = tent
	
	return closestTent
	
func _getPlayerTents():
	var playerTents = []
	
	for member in get_tree().get_nodes_in_group("PlayerTents"):
		playerTents.append(member)
	
	return playerTents

func _createEnemyBishop(closestTent):
	var enemyPlayer = enemy_player.instance()
	enemyPlayer.setTeam(getTeam())
	enemyPlayer.setHome(get_parent())
	
	var path = get_parent().get_parent().get_parent().findPath(parentSquare.global_position, closestTent.get_parent().global_position)
	
	grid.add_child(enemyPlayer)
	enemyPlayer.travelPath(path)
	
	return enemyPlayer
	

func _moveSoldiersFromTentToBishop(enemyBishop):
	var soldiers = takeDefendersFromTent()
	for soldier in soldiers:
		soldier.setTarget(enemyBishop)
	enemyBishop.followers = soldiers

func getTargetableNode(): return parentSquare
func takeDefendersFromTent(): return parentTent.takeDefendersFromTent()
