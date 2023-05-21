extends Node2D

var team = 1
var followers = []
var path
var homenode
var timer = Timer.new()

func setHome(home):
	homenode = home
	
func setTeam(num):
	self.team = num
	
func travelPath(path:Array):
	add_child(timer)
	timer.connect("timeout",self,"next")
	timer.start()
	self.path = path
	
func next():
	var pos = path.pop_front()
	if pos : global_position = pos
	else: timer.stop()


func takeSoldiersFromPlayer():
	var result = followers
	followers = []	
	return result

func getTeam():
	return team

func destroyIfNotHuman():
	for follower in followers:
		follower.queue_free()
	queue_free()
