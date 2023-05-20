extends KinematicBody2D
signal hit

export var width = 12
export var heigth = 9
export var cell_width = 40
export var start_coord_x = 40
export var start_coord_y = 40
export var speed = 200

func _ready():
	position.x = start_coord_x
	position.y = start_coord_y
	$CollisionShape2D.disabled = false
	$AnimatedSprite.animation = "default"
	var grid = get_parent().get_node("GridManager")
	width = grid.width
	heigth = grid.height


func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	
	move_and_collide(velocity*delta)
	
	position.x = clamp(position.x, start_coord_x, width*cell_width)
	position.y = clamp(position.y, start_coord_y, heigth*cell_width)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.flip_h = false
	


func _on_Player_body_entered(body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)
