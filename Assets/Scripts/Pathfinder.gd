extends KinematicBody2D

var path
var timer = Timer.new()
var attackerID
var followers = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func setAttackerID(id:int):
	attackerID = id
	
func travelPath(path:Array):
	add_child(timer)
	timer.connect("timeout",self,"next")
	timer.start()
	self.path = path
	
func next():
	var pos = path.pop_front()
	if pos : global_position = pos
	else: timer.stop()
	add_to_group("AIPlayer")

func getFollowers():
	return followers
