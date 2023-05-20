extends Node


# Declare member variables here. Examples:
var nearbySoldiers = []
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkInput()

	

func _on_body_entered(body:Node):
	if body.is_in_group("Soldiers"):
		if !(body in nearbySoldiers):
			nearbySoldiers.append(body.get_parent())
	

func _on_body_exited(body:Node):
	if body.is_in_group("Soldiers"):
		nearbySoldiers.erase(body.get_parent())
	

func _checkInput():
	if Input.is_action_pressed("command_troops"):
		commandSoldiers()

	
func commandSoldiers():
	for soldier in nearbySoldiers:
		soldier.get_parent().remove_child(soldier)
		self.get_parent().add_child(soldier)
		print(soldier.name + " seuraa.")
		
