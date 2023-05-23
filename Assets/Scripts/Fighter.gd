class_name Fighter
extends Node2D


var noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()
var angle = 0

#Home tent position
var target
var max_dist = 50
#Fighters won't move unless true

var isMoving = false
var cell_width
var width #width of grid
var height #height of grid
var isBeingDestroyed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	var grid = get_tree().current_scene.get_node("GridManager")
	cell_width = grid.tileSize
	width = grid.width
	height = grid.height
	startMoving()

func setTent(tent):
	setTarget(tent)	

func setTarget(_target):
	self.target = _target
	
func startMoving():
	while !isBeingDestroyed:
		yield(get_tree().create_timer(0.8), "timeout")
		changeDirection()
		if !is_instance_valid(target):return
		if (target.is_in_group("Player")):
			isMoving = true
		else:
			isMoving = !isMoving
	
func changeDirection():
	rng.randomize()
	var rng_number = rng.randf_range(-10.0, 10.0)
	var dir = noise.get_noise_2d(position.x+rng_number, position.y+rng_number)
	angle = dir*360 - PI/2.0
	
func move(delta):
		# Define some speed
	var speed = 100.0
	if !is_instance_valid(target):return
	var go_around_point = target.position
	# Calculate direction:
	# the Y coordinate must be inverted,
	# because in 2D the Y axis is pointing down
	var dir = Vector2(cos(angle), -sin(angle))
	var new_pos = (position + dir * (speed * delta))
	# Move
	#position = (position + dir * (speed * delta))
	var dist = new_pos.distance_to(go_around_point)
	var distbefore = position.distance_to(go_around_point)
	if (dist > max_dist and distbefore < dist):
		dir = Vector2(go_around_point.x-position.x, go_around_point.y-position.y)
		var direction_vector = dir.normalized() * speed * delta
		new_pos = position + direction_vector
	position = new_pos
	
	
	position.x = clamp(position.x, cell_width, width*cell_width)
	position.y = clamp(position.y, cell_width, height*cell_width)
	

	
func _process(delta):
	if isMoving:
		move(delta)
	

func destroy():
	isBeingDestroyed = true
	
	var safetyTimer = Timer.new()
	add_child(safetyTimer)
	safetyTimer.connect("timeout", self, "queue_free")
	safetyTimer.set_wait_time(1)
	safetyTimer.start()

func disableFollowIcon():
	if is_in_group("AllySoldiers"):
		var follow_icon = get_node("FollowIcon")
		if follow_icon != null:
			follow_icon.visible = false
