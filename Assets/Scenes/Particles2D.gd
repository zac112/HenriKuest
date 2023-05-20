extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
#	needs to be revised when soldiers can attack

	if get_owner().isMoving:
		visible = false
	else:
		visible = true
	pass
