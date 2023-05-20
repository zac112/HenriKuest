extends Node


# Declare member variables here. Examples:
var recruitable = false
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body:Node):
	if body.is_in_group("AIPlayer"):
		player = body
		
	if body.is_in_group("Player"):
		player = body
		recruitable = true

func _on_body_exited(body:Node):
	if body.is_in_group("Player"):
		recruitable = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkInput()
	

func _checkInput():
	if Input.is_action_just_pressed("command_troops") && recruitable:
		_recruitSoldiers()


func _recruitSoldiers():
	var soldiers = get_parent().getSoldiers()
	
	for soldier in soldiers:
		soldier.setTarget(player)
		player.getFollowers().append(soldier)
		soldier.modulate = Color(10, 1, 1)
	
	soldiers.clear()
	get_parent().resetTimer()


