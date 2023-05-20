extends Node


# Declare member variables here. Examples:
var recruitable = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body:Node):
	if body.is_in_group("Player"):
		player = body
		recruitable = true
		print("Pelaaja teltan lähellä")

func _on_body_exited(body:Node):
	if body.is_in_group("Player"):
		recruitable = false
		print("Pelaaja poistui teltan läheltä")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkInput()
	

func _checkInput():
	if Input.is_action_just_pressed("command_troops") && recruitable:
		_recruitSoldiers()


func _recruitSoldiers():
	var soldiers = get_parent().getSoldiers()
	
	for soldier in soldiers:
		#soldier.get_parent().remove_child(soldier)
		#player.add_child(soldier)
		soldier.setTarget(player)
		soldier.modulate = Color(10, 1, 1)
		print(soldier.name)
	
	soldiers.clear()
