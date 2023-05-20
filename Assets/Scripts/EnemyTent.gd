extends Node


# Declare member variables here. Examples:
var player
var combat = false
var attackers = []
var defenders
var battleTimer = Timer.new()
var parentSquare

# Called when the node enters the scene tree for the first time.
func _ready():
	parentSquare = get_parent().get_parent()
	defenders = get_parent().getSoldiers()
	add_child(battleTimer)
	battleTimer.wait_time = 2
	battleTimer.connect("timeout", self, "_killTroops")
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body:Node):
	if body.is_in_group("Player"):
		player = body
		combat = true
		_getAttackersFromPlayer()
		print("Pelaaja vihollisteltan lähellä")

func _on_body_exited(body:Node):
	if body.is_in_group("Player") && attackers.size() == 0:
		print("Pelaaja poistui vihollisteltan läheltä")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (combat == true && battleTimer.is_stopped()):
		battleTimer.start()
	

func _getAttackersFromPlayer():
	var playerSoldiers = player.getFollowers()
	for soldier in playerSoldiers:
		attackers.append(soldier)
		soldier.setTarget(parentSquare)
		playerSoldiers.clear()


func _killTroops():
	print("Combat in progress!")
	if attackers == null:
		return
	
	if attackers.size() == 0 || defenders.size() == 0:
		combat = false
		battleTimer.stop()
		print("Combat ended")
	else:
		attackers.pop_back().queue_free()
		defenders.pop_back().queue_free()
		print("Troops killed")
		
	print(defenders)
	print(attackers)
