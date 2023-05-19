extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const tile_path = preload("res://Assets/prefabs/Tile.tscn")
const leftup = preload("res://Assets/Sprites/Grid sprites/1.png")
const leftdown = preload("res://Assets/Sprites/Grid sprites/3.png")
const rightup = preload("res://Assets/Sprites/Grid sprites/2.png")
const rightdown = preload("res://Assets/Sprites/Grid sprites/4.png")




var tiles = [[]]

#makes variables editable from godot editor
export var width = 8
export var height = 6

export var tileSize = 48
var gridOffset = -48

# Called when the node enters the scene tree for the first time.
func _ready():
	generateGrid()
	pass # Replace with function body.
	

func generateGrid():
	for x in range(width):
		tiles.append([])
		for y in range(height):
			print(str(x) + " " + str(y))
			var pos = Vector2(x * tileSize - gridOffset, y * tileSize - gridOffset)
			
			var tile = tile_path.instance()
			#tile.get_node("Sprite").texture = 
			self.add_child(tile)

			
			tile.position = pos
			var texture = null
			tile.name = str(x) +  " " + str(y)
			if (y % 2 == 0 and x % 2 == 0):
				 texture = leftup
			elif (y % 2 == 0 and x % 2 == 1):
				texture = rightup
			elif (y % 2 == 1 and x % 2 == 0):
				texture = leftdown
			else:
				texture = rightdown
			tile.get_node("Sprite").texture = texture
			#var darker = ((x + y) % 2) == 1
			#if(darker):
			#	tile.get_node("Sprite").modulate = Color(0, 0, 1)
			

			tiles[x].append(tile)
		

func getTileWPos(worldPos):
	var x = int((worldPos.x + gridOffset) / tileSize)
	var y = int((worldPos.y + gridOffset) / tileSize)
	if (x >= width): x = width - 1
	if (y >= width): y = height - 1
	if (x <= 0): x = 0
	if (y <= 0): y = 0
	return tiles[x][y];
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
