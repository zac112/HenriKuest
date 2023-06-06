extends Sprite

var jumpSpeed = 20
var jumpAmount = 120
var time = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	var movement = cos(time * jumpSpeed) * jumpAmount
	
	if get_parent().isMoving:
		position.y += movement * delta
