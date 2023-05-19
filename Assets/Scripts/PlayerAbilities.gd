extends Node


# Declare member variables here. Examples:
export var maxDistanceToUseTent = 50
export var maxDistanceToCallSoldiers = 50
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkInput()
	
	
	
# Returns a list of soldiers within maxDistanceToCallSoldiers.
func _getNearbySoldiers():
	var soldiers = get_tree().get_nodes_in_group("Soldiers")
	var nearbySoldiers
	
	for soldier in soldiers:
		if soldier.global.position.distance_to(self.global.position) < maxDistanceToCallSoldiers:
			nearbySoldiers.add(soldier)
	
	return nearbySoldiers


func _checkInput():
	if Input.is_action_pressed("command_troops"):
		commandSoldiers()

func body_entered(body:Node):
	print(body)
	

func commandSoldiers():
	var nearbySoldiers = _getNearbySoldiers()
	
	for soldier in nearbySoldiers:
		soldier.get_parent.remove_child(soldier)
		add_child(soldier)
