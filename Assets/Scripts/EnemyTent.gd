extends Node


# Declare member variables here. Examples:
var player
var combat = false
var attackers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body:Node):
	if body.is_in_group("Player"):
		player = body
		combat = true
		_getAttackersFromPlayer()
		print("Pelaaja vihollisteltan lähellä")

func _on_body_exited(body:Node):
	if body.is_in_group("Player"):
		combat = false
		print("Pelaaja poistui vihollisteltan läheltä")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _getAttackersFromPlayer():
	var playerChildren = player.get_children()
	for child in playerChildren:
		print(child.name)
		if child.is_in_group("Soldiers"):
			attackers.append(child)
			child.get_parent().remove_child(child)
			add_child(child)
