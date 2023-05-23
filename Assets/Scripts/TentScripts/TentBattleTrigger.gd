extends Node

var battleScene = load("res://Assets/Scenes/Battle.tscn")
var currentBattle = null
var attacker_team = null
var currentAttacker = null
var parentSquare
var parentTent

# Called when the node enters the scene tree for the first time.
func _ready():
	parentTent = get_parent().get_parent()
	parentSquare = get_parent().get_parent().get_parent()
	connect("body_entered", self, "_on_body_entered")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _on_body_entered(body:Node):
	if !body.is_in_group("Bishop"): return
	if !body.is_in_group("Player") and get_parent() == body.homenode: return
	
	# Own village
	if (body.getTeam() == parentTent.getOwnerTeamNumber()):
		return
	
	# Only one team can attack a tent at the same time
	if (attacker_team != null and attacker_team != body.getTeam()):
		return
	
	# Make sure AI player is near its destination before triggering battle.
	if !body.is_in_group("Player"):
		if !body.isPathAlmostEmpty():
			return
	
	if currentBattle == null:
		attacker_team = body.getTeam()
		currentAttacker = body
		currentBattle = battleScene.instance()
		add_child(currentBattle)
		parentTent.stopSpawnTimer()
	else:
		body.destroyIfNotHuman()
	
	
func getTeam(): return parentTent.getOwnerTeamNumber()
func getCurrentAttacker(): return currentAttacker
func getTargetableNode(): return parentSquare
func takeDefendersFromTent(): return parentTent.takeDefendersFromTent()
func getCurrentBattle(): return currentBattle

func endBattle(winnerTeam, remainingTroops):
	currentBattle = null
	attacker_team = null
	
	var newTent = parentTent.setOwnership(winnerTeam)
	newTent.addSoldiers(remainingTroops)
	newTent.startSpawnTimer()
