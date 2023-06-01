extends Node2D

var team = 1
var followers = []
var path
var homenode
var timer = Timer.new()
var slappingHand

func _ready():
	slappingHand = get_node("SlappingHand")

func setHome(home):
	homenode = home
	
func setTeam(num):
	self.team = num
	
func travelPath(_path:Array):
	add_child(timer)
	timer.connect("timeout",self,"next")
	timer.start()
	self.path = _path
	
func next():
	var pos = path.pop_front()
	if pos : global_position = pos
	else: timer.stop()


func isPathAlmostEmpty():
	return len(path) < 2

func takeSoldiersFromPlayer():
	var result = followers
	followers = []
	return result

func getTeam(): return team

func destroyIfNotHuman():
	for follower in followers:
		follower.destroy()
	queue_free()

	var safetyTimer = Timer.new()
	add_child(safetyTimer)
	safetyTimer.connect("timeout", self, "queue_free")
	safetyTimer.set_wait_time(1)
	safetyTimer.start()

func getSlapped():
	timer.stop()
	slappingHand.visible = true
	slappingHand.play()
	yield($SlappingHand, "animation_finished")
	destroyIfNotHuman()
