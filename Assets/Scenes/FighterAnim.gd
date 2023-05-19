extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var jumpSpeed = 20
var jumpAmount = 120
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var movement = cos(time * jumpSpeed) * jumpAmount

	position.y += movement * delta
