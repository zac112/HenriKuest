extends KinematicBody2D

var path
var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(0,0)
	

func travelPath(path:Array):
	add_child(timer)
	timer.connect("timeout",self,"next")
	timer.start()
	self.path = path
	
func next():
	var pos = path.pop_front()
	if pos : global_position = pos
	else: timer.stop()

