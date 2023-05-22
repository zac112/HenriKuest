extends Node



# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_body_entered(body:Node):
	if !body.is_in_group("Bishop"): return		
	if !body.is_in_group("Player") and get_parent()==body.homenode: return
	
	#own village
#	if (body.team == getTeam()):
#		if (body.team != 0):
#			get_parent().addSoldiers(body.getFollowers())
#		return
	
		#only one team can attack a tent at the same time
	if (get_node("../Area2D").attacker_team != null and get_node("../Area2D").attacker_team != body.team):
		return
	
#	if currentBattle == null:
#		attacker_team = body.team
#		currentAttacker = body
#		currentBattle = battleScene.instance()
#		add_child(currentBattle)
#		attackTimer.stop()
#		get_parent().stopSpawnTimer()
	
