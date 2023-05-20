extends Node


# Declare member variables here. Examples:
var player
var combat = false
var attackers = []
var defenders = []
var battleTimer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
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
		_simulateCombat()

func _on_body_exited(body:Node):
	if body.is_in_group("Player") && attackers.size() == 0:
		combat = false
		print("Pelaaja poistui vihollisteltan läheltä")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (combat == true):
		_simulateCombat()
	

func _getAttackersFromPlayer():
	var playerChildren = player.get_children()
	for child in playerChildren:
		print(child.name)
		if child.is_in_group("Soldiers"):
			attackers.append(child)
			child.get_parent().remove_child(child)
			add_child(child)


func _simulateCombat():
	defenders = get_parent().getSoldiers()
	battleTimer.start()
	

func _killTroops():
	if attackers.size() == 0 || defenders.size() == 0:
		combat = false
		battleTimer.stop()
		print("Combat ended")
	else:
		attackers.pop_back()
		defenders.pop_back()
		print("Troops killed")
