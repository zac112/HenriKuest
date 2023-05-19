class_name Fighter
extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var noise = OpenSimplexNoise.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	
func _process(delta):

	var dir = noise.get_noise_2d(position.x, position.y)

	print(dir)
	# ...
	# look at
	# ...

	# You need an angle rotated 90 degrees,
	# because look_at considers that an angle of 0 is pointing up, not right.
	# (Adjust it if it's wrong in your case, depends on how your sprite looks)
	var angle = dir*360 - PI/2.0

	# Define some speed
	var speed = 100.0

	# Calculate direction:
	# the Y coordinate must be inverted,
	# because in 2D the Y axis is pointing down
	dir = Vector2(cos(angle), -sin(angle))

	# Move
	position = (position + dir * (speed * delta))
