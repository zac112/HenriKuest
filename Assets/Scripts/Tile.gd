class_name Tile
extends Node


var content : Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func addContent(content : Node):
	self.content = content
	self.add_child(content)
	
func clearTile():
	self.remove_child(content)
