extends Particles2D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
#	needs to be revised when soldiers can attack

	if get_owner().isMoving:
		visible = false
	else:
		visible = true
