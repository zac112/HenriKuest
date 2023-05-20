extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var path

# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(0,0)
	

func travelPath(path:Array):
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",self,"next")
	timer.start()
	self.path = path
	
func next():
	global_position = path.pop_front()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
