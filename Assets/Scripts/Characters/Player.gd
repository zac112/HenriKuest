extends KinematicBody2D
signal hit

var width = 12
var heigth = 9
var cell_width = 40
var start_coord_x = 40
var start_coord_y = 40
export var player_start_x = 40
export var player_start_y = 10
export var speed = 200
var followers = []
var team = 0
var bishopSlapArea
var bishopSlapAvailable = true
var slapCooldownTimer
var slapCooldown = 8
onready var mask = get_node("SlapFillBar/Light2D")


func getTeam(): return team
func destroyIfNotHuman(): pass
func addFollower(follower): followers.append(follower)

func _ready():
	$CollisionShape2D.disabled = false
	$AnimatedSprite.animation = "default"
	var grid = get_parent().get_node("GridManager")
	width = grid.width
	heigth = grid.height
	start_coord_x = grid.tileSize
	start_coord_y = 10
	position.x = player_start_x
	position.y = player_start_y
	cell_width = grid.tileSize
	bishopSlapArea = get_node("BishopSlapArea")
	setUpSlapCooldownTimer()


func _process(_delta):
	processMovement()
	processOtherInput()
	processSlapCooldownBar()

func processMovement():
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
	
# warning-ignore:return_value_discarded
	move_and_slide(velocity)
	
	position.x = clamp(position.x, start_coord_x, width*cell_width)
	position.y = clamp(position.y, start_coord_y, heigth*cell_width)
	
	if velocity.x != 0:
		$AnimatedSprite.animation = "right"
		$AnimatedSprite.flip_h = velocity.x < 0
	else:
		$AnimatedSprite.animation = "default"
		$AnimatedSprite.flip_h = false


func _on_Player_body_entered(_body):
	emit_signal("hit")
	$CollisionShape2D.set_deferred("disabled", true)


func takeSoldiersFromPlayer():
	var soldiers = followers
	followers = []
	return soldiers


func processOtherInput():
	if (bishopSlapAvailable && Input.is_action_pressed("bishop_slap")):
		attemptBishopSlap()

func attemptBishopSlap():
	var bishopsInRange = getEnemyBishopsInRange()
	if (bishopsInRange != null):
		if (len(bishopsInRange) < 1):
			return
		else:
			slapCooldownTimer.stop()
			bishopSlap(bishopsInRange)

func getEnemyBishopsInRange():
	var bodiesInRange = bishopSlapArea.get_overlapping_bodies()
	var bishopsInRange = []
	
	for body in bodiesInRange:
		if body.is_in_group("Slappable"):
			bishopsInRange.append(body)
	
	return bishopsInRange

func setUpSlapCooldownTimer():
	slapCooldownTimer = Timer.new()
	add_child(slapCooldownTimer)
	slapCooldownTimer.connect("timeout", self, "restoreBishopSlap")
	slapCooldownTimer.wait_time = slapCooldown


func bishopSlap(bishopsInRange):
	for bishop in bishopsInRange:
		bishop.getSlapped()
		
	bishopSlapAvailable = false
	slapCooldownTimer.start()


func restoreBishopSlap():
	bishopSlapAvailable = true

func processSlapCooldownBar():
	var percentDone = slapCooldownTimer.get_time_left()/slapCooldownTimer.get_wait_time()
	if mask:
		mask.setScale(1-percentDone)
