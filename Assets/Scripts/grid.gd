extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const tile_path = preload("res://Assets/prefabs/Tile.tscn")

var tiles = [[]]

var width = 8
var height = 3

var tileSize = 50
var gridOffset = 100

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
			self.add_child(tile)
			
			tile.position = pos

			tile.name = str(x) +  " " + str(y)

			var darker = ((x + y) % 2) == 1
			if(darker):
				tile.get_node("Sprite").modulate = Color(0, 0, 1)
			

			tiles[x].append(tile)
		

func getTileWPos(worldPos):
	var x = int((worldPos.x + gridOffset) / tileSize +0.5)
	var y = int((worldPos.y + gridOffset) / tileSize +0.5)
	if (x >= width): x = width - 1
	if (y >= width): y = height - 1
	if (x <= 0): x = 0
	if (y <= 0): y = 0
	return tiles[x][y]
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
