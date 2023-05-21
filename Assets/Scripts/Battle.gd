extends Node


# Declare member variables here. Examples:
var defenders = []
var attackers = []
var battleTimer = Timer.new()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_simulateCombat()


func _simulateCombat():
	pass
