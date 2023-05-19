extends Node

# Declare member variables here.
var timer = Timer.new()
var spawnableUnits
var currentProduction = 0
var unit1 = load("res://Assets/Scenes/Soldier.tscn")
var ownerPlayerNumber

export var timeBetweenSpawns = 5


# Called when the node enters the scene tree for the first time.
func _ready():
	spawnableUnits = [unit1]
	add_child(timer)
	timer.start()
	timer.wait_time = timeBetweenSpawns
	timer.connect("timeout", self, "_handleSpawning")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

# Called by timer countdown. Spawns the unit currently in production.
func _handleSpawning():
	var unit = spawnableUnits[currentProduction]

	var spawn = unit.instance()
	spawn.position.x = self.position.x + 10
	spawn.position.y = self.position.y + 10
	add_child(spawn)
	
	
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
	
