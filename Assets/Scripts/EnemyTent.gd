extends Node


# Declare member variables here. Examples:
var player
var combat = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body:Node):
	if body.is_in_group("Player"):
		player = body
		combat = true
		print("Pelaaja vihollisteltan lähellä")

func _on_body_exited(body:Node):
	if body.is_in_group("Player"):
		combat = false
		print("Pelaaja poistui vihollisteltan läheltä")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkForCombat()
	

func _checkForCombat():
	pass
