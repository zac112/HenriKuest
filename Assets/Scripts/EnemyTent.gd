extends Node


# Declare member variables here. Examples:
var player
var combat = false
var attackers = []
var defenders = []
var battleTimer = Timer.new()
var parentSquare
export var minDefendersToAttack = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	parentSquare = get_parent().get_parent()
	defenders = get_parent().getSoldiers()
	add_child(battleTimer)
	battleTimer.wait_time = 1
	battleTimer.connect("timeout", self, "_killTroops")
	connect("body_entered", self, "_on_body_entered")
	#connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body:Node):
	if body.is_in_group("Player"):
		player = body
		combat = true
		_getAttackersFromPlayer()

func _on_body_exited(body:Node):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (combat == true && battleTimer.is_stopped()):
		battleTimer.start()
		
	#if combat == false && defenders.size() >= minDefendersToAttack:
		#_attack()
	

func _attack():
	var playerTents = _getPlayerTents()
	
	if playerTents.size() == 0:
		return
	
	var closestTent = playerTents[0]
	
	#for tent in playerTents:
		#if tent.get_global_pos().distance_to(parentSquare) < closestTent.get_global_pos().distance_to(parentSquare):
			#closestTent = tent
	
	for defender in defenders:
		defender.setTarget(closestTent.get_parent())
	
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
		
