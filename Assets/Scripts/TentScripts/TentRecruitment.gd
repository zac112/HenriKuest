extends Node

var recruit
var recruitable = false
var player
var parentSquare
var particle_effect_scene = preload("res://Assets/Scenes/recruit_particle.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
	parentSquare = get_parent().get_parent()
	recruit = get_parent().get_node("Sprite")
	recruit.visible = false

func _on_body_entered(body:Node):		
	if body.is_in_group("Player"):
		player = body
		recruitable = true
		recruit.visible = true

func _on_body_exited(body:Node):
	if body.is_in_group("Player"):
		recruitable = false
		recruit.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_checkInput()

func _checkInput():
	if Input.is_action_just_pressed("command_troops") && recruitable:
		_recruitSoldiers()


func _recruitSoldiers():
	var soldiers = get_parent().takeDefendersFromTent()
	
	if (soldiers.size() == 0): return

	for soldier in soldiers:
		soldier.setTarget(player)
		player.addFollower(soldier)
		soldier.modulate = Color(10, 1, 1)
		soldier.get_node("FollowIcon").visible = true
		
	var particle = particle_effect_scene.instance()
	add_child(particle)
	particle.global_position = self.global_position
	#get_parent().resetTimer()
