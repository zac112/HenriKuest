extends Node

var spawnableUnits
var unit0 = load("res://Assets/Scenes/Characters/Soldier_ally.tscn")
var unit1 = load("res://Assets/Scenes/Characters/Soldier.tscn")
var unit2 = load("res://Assets/Scenes/Characters/Soldier2.tscn")
var unit3 = load("res://Assets/Scenes/Characters/Soldier3.tscn")
var timer = Timer.new()
var currentProduction
var grid
onready var mask = get_node("FillBar/Light2D")

export var timeBetweenSpawns = 20



# Called when the node enters the scene tree for the first time.
func _ready():
	spawnableUnits = [unit0, unit1, unit2, unit3]
	add_child(timer)
	resetTimer()
	timer.connect("timeout", self, "_handleSpawning")
	grid = get_tree().current_scene.get_node("GridManager")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var percentDone = timer.get_time_left()/timer.get_wait_time()
	if mask:
		mask.setScale(1-percentDone)


# Returns the duration of next unit production.
# Dependent on the current number of soldiers in tent.
func getNextWaitTime():
	var x = get_parent().getNumberOfSoldiers()
	var a = 1.17
	var b = -1.83
	var c = 3
	return a*x*x+b*x+c

func stopSpawnTimer(): timer.stop()
func startSpawnTimer(): timer.start()

func resetTimer():
	timer.stop()
	timer.set_wait_time(getNextWaitTime())
	timer.start()

# Called by timer countdown. Spawns the unit currently in production.
func _handleSpawning():
	var unit = spawnableUnits[get_parent().getOwnerTeamNumber()]

	var spawn = unit.instance()
	spawn.setTent(self.get_parent().get_parent())
	grid.add_child(spawn)
	spawn.position.x = self.get_parent().get_parent().position.x
	spawn.position.y = self.get_parent().get_parent().position.y
	_addProducedSoldierToTent(spawn)
	
	resetTimer()
	
func _addProducedSoldierToTent(soldier): get_parent().addSoldier(soldier)

# Set the next produced unit and reset timer.
func changeProduction(selection):
	if selection >= 0 && selection < spawnableUnits.size():
		currentProduction = selection
		resetTimer()
