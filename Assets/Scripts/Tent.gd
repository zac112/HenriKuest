extends Node

# To be deleted?
var timer = Timer.new()
var spawnableUnits
var currentProduction = 1
var unit0 = load("res://Assets/Scenes/Soldier_ally.tscn")
var unit1 = load("res://Assets/Scenes/Soldier.tscn")
var unit2 = load("res://Assets/Scenes/Soldier2.tscn")
var unit3 = load("res://Assets/Scenes/Soldier3.tscn")
export var timeBetweenSpawns = 20
onready var mask = get_node("FillBar/Light2D")


var soldiers = []
export var ownerTeamNumber = 0
var grid

# New stuff and stuff kept from old code

func getOwnerTeamNumber(): return ownerTeamNumber
func getNumberOfSoldiers(): return len(soldiers)
func addSoldier(soldier):
	soldiers.append(soldier)
	soldier.setTarget(self.get_parent())



# Old stuff below to be refactored
	
# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Tents")
	spawnableUnits = [unit0, unit1, unit2, unit3]
	add_child(timer)
	resetTimer()
	timer.connect("timeout", self, "_handleSpawning")
	grid = get_tree().current_scene.get_node("GridManager")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var percentDone = timer.get_time_left()/timer.get_wait_time()
	if mask:
		mask.setScale(1-percentDone)
	
	
# Change the ownership of the tent.
func setOwnership(targetPlayerNumber):
	if targetPlayerNumber == ownerTeamNumber:return self
		
	grid.removeTent(ownerTeamNumber)
	ownerTeamNumber = targetPlayerNumber
	var newTent = grid.spawnTent(get_parent(), targetPlayerNumber)
	_destroy()
	return newTent
	
	
# Destroys the tent and its child timer.
func _destroy():
	remove_child(timer)
	queue_free()
	
func addSoldiers(tempSoldiers):
	for soldier in tempSoldiers:
		soldier.modulate = Color(1, 1, 1)
		var follow_icon = soldier.get_node("FollowIcon")
		if follow_icon != null:
			follow_icon.visible = false
		soldier.setTarget(self.get_parent())
	soldiers.append_array(tempSoldiers)

	
func isInCombat():
	return get_node("Area2D2").currentBattle != null
	


func takeDefendersFromTent():
	var defenders = soldiers
	soldiers = []	
	return defenders
	

################################

func getNextWaitTime():
	var x = len(soldiers)
	var a = 1.17
	var b = -1.83
	var c = 3
	return a*x*x+b*x+c

func resetTimer():
	timer.stop()
	timer.set_wait_time(getNextWaitTime())
	timer.start()

func getCurrentOwner():
	return ownerTeamNumber


func stopSpawnTimer():
	timer.stop()


func startSpawnTimer():
	timer.start()

func getDefenderAmount():
	return len(soldiers)


# Called by timer countdown. Spawns the unit currently in production.
func _handleSpawning():
	var unit = spawnableUnits[ownerTeamNumber]

	var spawn = unit.instance()
	spawn.setTent(self.get_parent())
	grid.add_child(spawn)
	spawn.position.x = self.get_parent().position.x
	spawn.position.y = self.get_parent().position.y
	soldiers.append(spawn)
	
	resetTimer()
	
	
# Set the next produced unit and reset timer.
func changeProduction(selection):
	if selection >= 0 && selection < spawnableUnits.size():
		currentProduction = selection
		resetTimer()
