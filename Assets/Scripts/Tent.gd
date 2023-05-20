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

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_to_group("Tents")
	spawnableUnits = [unit0, unit1, unit2, unit3]
	add_child(timer)
	timer.start()
	timer.wait_time = timeBetweenSpawns
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
	print(str(self.position.x) + " " + str(self.position.y))
	soldiers.append(spawn)
	
	
# Set the next produced unit and reset timer.
func changeProduction(selection):
	if selection >= 0 && selection < spawnableUnits.size():
		timer.stop()
		currentProduction = selection
		timer.start()
	
	
# Change the ownership of the tent.
func setOwnership(targetPlayerNumber):
	ownerPlayerNumber = targetPlayerNumber
	
	
# Destroys the tent and its child timer.
func _destroy():
	remove_child(timer)
	queue_free()
	

func getSoldiers():
	return soldiers
