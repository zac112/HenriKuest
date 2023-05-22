extends Node

var soldiers = []
export var ownerTeamNumber = 0
var grid
var tentProduction = load("res://Assets/Scenes/TentProduction.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	var production = tentProduction.instance()
	add_child(production)
	
	self.add_to_group("Tents")
	grid = get_tree().current_scene.get_node("GridManager")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	

func getOwnerTeamNumber(): return ownerTeamNumber
func getNumberOfSoldiers(): return len(soldiers)
func _destroy(): queue_free()
func isInCombat(): return get_node("Area2D2").currentBattle != null


# Change the ownership of the tent by destroying current one and spawning
# new one for the appropriate team.
func setOwnership(targetTeamNumber):
	if targetTeamNumber == ownerTeamNumber:return self
		
	grid.removeTent(ownerTeamNumber)
	ownerTeamNumber = targetTeamNumber
	var newTent = grid.spawnTent(get_parent(), targetTeamNumber)
	_destroy()
	return newTent

func addSoldier(soldier):
	soldiers.append(soldier)
	soldier.setTarget(self.get_parent())

func addSoldiers(tempSoldiers):
	for soldier in tempSoldiers:
		soldier.modulate = Color(1, 1, 1)
		var follow_icon = soldier.get_node("FollowIcon")
		if follow_icon != null:
			follow_icon.visible = false
		addSoldier(soldier)


func takeDefendersFromTent():
	var defenders = soldiers
	soldiers = []	
	return defenders
