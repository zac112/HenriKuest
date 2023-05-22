extends Node

const enemy_player = preload("res://Assets/Scenes/EnemyPlayer.tscn")
var rng = RandomNumberGenerator.new()
var parentSquare
var parentTent
var attackTimer = Timer.new()
export var minDefendersToAttack = 1

var grid
# Called when the node enters the scene tree for the first time.
func _ready():
	parentTent = get_parent()
	parentSquare = get_parent().get_parent()
	add_child(attackTimer)
	attackTimer.wait_time = 1
	attackTimer.connect("timeout", self, "_tryAttack")
	attackTimer.start()
	
	connect("body_entered", self, "_on_body_entered")
	grid = get_tree().current_scene.get_node("GridManager")
	rng.randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if getTeam() != 0 and parentTent.isInCombat() == false:
		if rng.randi_range(0, 10000) == 1:
			_attack()

func getTeam():
	return get_parent().getOwnerTeamNumber()

func _tryAttack():
	var x = get_parent().getNumberOfSoldiers()
	var a = 1.67
	var b = 5
	var c = -16.7
	if getTeam() != 0:
		if rng.randi_range(0, 100) < a*x*x + b*x + c:
			_attack()
			
func _attack():
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
	#enemyPlayer.position = parentSquare.position

	var path = get_parent().get_parent().get_parent().findPath(parentSquare.global_position, closestTent.get_parent().global_position)
	
	var soldiers = takeDefendersFromTent()
	for soldier in soldiers:
		soldier.setTarget(enemyPlayer)
	enemyPlayer.followers = soldiers
		
	grid.add_child(enemyPlayer)
	enemyPlayer.travelPath(path)
	
	
func _getPlayerTents():
	var playerTents = []
	
	for member in get_tree().get_nodes_in_group("PlayerTents"):
		playerTents.append(member)
	
	return playerTents
	

func getTargetableNode(): return parentSquare
func takeDefendersFromTent(): return parentTent.takeDefendersFromTent()
