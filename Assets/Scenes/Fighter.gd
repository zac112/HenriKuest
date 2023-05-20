class_name Fighter
extends Node2D


var noise = OpenSimplexNoise.new()
var rng = RandomNumberGenerator.new()
var angle = 0
#Home tent position
var home_tent = Vector2(50,50)
var go_around_point = home_tent
var max_dist = 50

#Fighters won't move unless true

var isMoving = false
var cell_width
var width #width of grid
var height #height of grid


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
	print("Width " + str(width) + " h: " + str(height))
	startMoving()

func setTent(position):
	home_tent = position
	go_around_point = home_tent	

func startMoving():
	while true:
		yield(get_tree().create_timer(0.8), "timeout")
		changeDirection()
		isMoving = !isMoving
	
func changeDirection():
	rng.randomize()
	var rng_number = rng.randf_range(-10.0, 10.0)
	var dir = noise.get_noise_2d(position.x+rng_number, position.y+rng_number)
	angle = dir*360 - PI/2.0
	
func move(delta):
		# Define some speed
	var speed = 100.0

	# Calculate direction:
	# the Y coordinate must be inverted,
	# because in 2D the Y axis is pointing down
	var dir = Vector2(cos(angle), -sin(angle))
	var new_pos = (position + dir * (speed * delta))
	go_around_point = get_parent().position
	# Move
	#position = (position + dir * (speed * delta))
	var dist = new_pos.distance_to(go_around_point)
	var distbefore = position.distance_to(go_around_point)
	var glob = (global_position + dir * (speed*delta))
	if (glob.x < cell_width or glob.x > width*cell_width):
		return
	if (glob.y < cell_width or glob.y > height * cell_width):
		return
	if (dist > max_dist and distbefore < dist):
		dir = Vector2(-position.x, -position.y)
		var direction_vector = dir.normalized() * speed * delta
		new_pos = position + direction_vector
	position = new_pos
	
	
	#position.x = clamp(position.x, cell_width, width*cell_width)
	#position.y = clamp(position.y, cell_width, height*cell_width)
	

	
func _process(delta):
	if isMoving:
		move(delta)
	


