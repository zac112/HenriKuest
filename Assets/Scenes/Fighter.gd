class_name Fighter
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()
var angle = 0

#Fighters won't move unless true
var moveTime = false


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	startMoving()
	

func startMoving():
	while true:
		yield(get_tree().create_timer(0.67), "timeout")
		changeDirection()
		moveTime = !moveTime
	
func changeDirection():
	var dir = noise.get_noise_2d(position.x, position.y)
	angle = dir*360 - PI/2.0
	
func move(delta):
		# Define some speed
	var speed = 100.0

	# Calculate direction:
	# the Y coordinate must be inverted,
	# because in 2D the Y axis is pointing down
	var dir = Vector2(cos(angle), -sin(angle))

	# Move
	position = (position + dir * (speed * delta))
	
func _process(delta):
	if moveTime:
		move(delta)
	


