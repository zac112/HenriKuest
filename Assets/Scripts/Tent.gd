extends Node

# Declare member variables here.
var timer = Timer.new()
var spawnableUnits
var currentProduction = 1
var unit0 = load("res://Assets/Scenes/Soldier_ally.tscn")
var unit1 = load("res://Assets/Scenes/Soldier.tscn")
var unit2 = load("res://Assets/Scenes/Soldier2.tscn")
var unit3 = load("res://Assets/Scenes/Soldier3.tscn")
var soldiers = []

export var ownerPlayerNumber = 0
export var timeBetweenSpawns = 20
onready var mask = get_node("FillBar/Light2D")
var grid

func getNextWaitTime():
	var x = len(soldiers)
	var a = 1.17
	var b = -1.83
	var c = 3
	return a*x*x+b*x+c
	
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
	

# Called by timer countdown. Spawns the unit currently in production.
func _handleSpawning():
	var unit = spawnableUnits[ownerPlayerNumber]

	var spawn = unit.instance()
	spawn.setTent(self.get_parent())
	grid.add_child(spawn)
	spawn.position.x = self.get_parent().position.x
	spawn.position.y = self.get_parent().position.y
	soldiers.append(spawn)
	
	resetTimer()
	#print(timer.get_time_left())
	
	
	
# Set the next produced unit and reset timer.
func changeProduction(selection):
	if selection >= 0 && selection < spawnableUnits.size():
		currentProduction = selection
		resetTimer()
	
	
	
# Change the ownership of the tent.
func setOwnership(targetPlayerNumber):
	grid.removeTent(ownerPlayerNumber)
	ownerPlayerNumber = targetPlayerNumber
	_destroy()
	var newTent = grid.spawnTent(get_parent(), targetPlayerNumber)
	return newTent
	
	
# Destroys the tent and its child timer.
func _destroy():
	remove_child(timer)
	queue_free()
	
func addSoldiers(tempSoldiers):
	for soldier in tempSoldiers:
		soldier.modulate = Color(1, 1, 1)
		soldier.setTarget(self.get_parent())
	soldiers.append_array(tempSoldiers)


func resetTimer():
	timer.stop()
	timer.set_wait_time(getNextWaitTime())
	timer.start()
	
func isInCombat():
	var attackers = get_node("Area2D").attackers
	return attackers != null and len(attackers)>0


# To be removed when new battle system works
func getSoldiers():
	return soldiers



# New battle system stuff below
func getDefenders():
	var defenders = []
	for soldier in soldiers:
		defenders.append(soldier)
	
	return defenders
	

func removeDefenders(defendersToBeRemoved):
	for defender in defendersToBeRemoved:
		soldiers.erase(defender)
