extends Node2D

const tile_path = preload("res://Assets/prefabs/Tile.tscn")
const leftup = preload("res://Assets/Sprites/Grid sprites/1.png")
const leftdown = preload("res://Assets/Sprites/Grid sprites/3.png")
const rightup = preload("res://Assets/Sprites/Grid sprites/2.png")
const rightdown = preload("res://Assets/Sprites/Grid sprites/4.png")

const tent = preload("res://Assets/Scenes/Tent.tscn")
const tent2 = preload("res://Assets/Scenes/Tent2.tscn")
const tent3 = preload("res://Assets/Scenes/Tent3.tscn")
const tent4 = preload("res://Assets/Scenes/Tent4.tscn")
const tent_destroyed = preload("res://Assets/Scenes/Tent_destroyed.tscn")


var tiles = [[]]
var tents 
var obstaclePositions = []
var obstacles = [preload("res://Assets/Scenes/Obstacle.tscn"),
preload("res://Assets/Scenes/Obstacle2.tscn")]

#makes variables editable from godot editor
export var width = 60
export var height = 40

export var gridID = 0 # 0 is for "random" generation while other grids need to have IDs

export var tileSize = 48

var gridOffset = -48
var spawnedTentsCount = 0
var playerTents = 0
var canWin = false


# Called when the node enters the scene tree for the first time.
func _ready():
	tents = [tent,tent2,tent3,tent4,tent_destroyed]
	if gridID == 0:
		generateGrid()
	else:
		loadGrid(gridID)
	
	
	var timer = Timer.new()
	add_child(timer)
	timer.connect("timeout",self,"startAI")
	timer.set_one_shot(true)
	timer.start()
	
func startAI():
	var path = findPath(Vector2(0,0), Vector2(528,528))
	var AI = load("res://Assets/Scenes/PlayerAI.tscn").instance()
	add_child(AI)
	AI.global_position = Vector2(50,50)
	AI.travelPath(path)
	

func generateGrid():
	var rng = RandomNumberGenerator.new()
	for x in range(width):
		tiles.append([])
		print(x)
		for y in range(height):
			#print(str(x) + " " + str(y))
			var pos = Vector2(x * tileSize - gridOffset, y * tileSize - gridOffset)
			
			var tile = tile_path.instance()
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
			
			
			if rng.randi_range(0,100) < 5:
				spawnTent(tile, rng.randi_range(0,len(tents)-1))
			elif rng.randi_range(0,10) < 2:
				tile.addContent(obstacles[rng.randi_range(0,len(obstacles)-1)].instance())
				obstaclePositions.append(Vector2(x,y))
			

			tiles[x].append(tile)
	canWin = true
		
func victory():
	get_tree().change_scene("res://Assets/Scenes/winScreen.tscn")


	
func spawnTent(tile, number):
	if number == 0:
		playerTents+=1
	if number != 4:
		spawnedTentsCount+=1
	print("Player: " + str(playerTents) + " Total: " + str(spawnedTentsCount))
	if (playerTents >= spawnedTentsCount and canWin):
		victory()

	var tent = tents[number].instance()
	tile.get_node(".").addContent(tent)
	
	return tent
	
	
func getTile(x,y):
	return tiles[x][y]
	
func CoordToWpos(coord:Vector2):
	return Vector2(coord.x*tileSize-gridOffset, coord.y*tileSize-gridOffset)
	
func WPosToCoord(worldPos:Vector2):
	var x = int((worldPos.x + gridOffset) / tileSize)
	var y = int((worldPos.y + gridOffset) / tileSize)
	if (x >= width): x = width - 1
	if (y >= width): y = height - 1
	if (x <= 0): x = 0
	if (y <= 0): y = 0
	return Vector2(x,y)
	
func getTileWPos(worldPos):
	var pos = WPosToCoord(worldPos)	
	return tiles[pos.x][pos.y];
	
func removeTent(number):
	if number == 0:
		playerTents-=1
	spawnedTentsCount-=1
	
#Start and end in World position
func findPath(start:Vector2, end:Vector2):
	start = WPosToCoord(start)
	end = WPosToCoord(end)
	var stack = [start]
	var path = {start:null}
	var visited = {}
	
	while stack:
		var pos = stack.pop_front()
		if pos in visited: continue			
		
		#If found path
		if pos.is_equal_approx(end):
			var result = [end]
			while result.back() != null:
				for toPos in path.keys():
					var fromPos = path[toPos]
					if toPos.is_equal_approx(result.back()):
						#print(fromPos," -> ",toPos)
						result.append(fromPos)
						break
								
			result.pop_back() #remove null at end
			result.invert()
			for i in range(len(result)):
				result.append(CoordToWpos(result.pop_front()))
			return result
		
		#get neighbors
		for p in [[1,0],[-1,0],[0,1],[0,-1]]:
			var x = p[0]+pos.x
			var y = p[1]+pos.y
			var newPos = Vector2(x,y) 
			
			if x < 0 or y < 0 or x >= width or y >= height: continue
			if newPos in obstaclePositions: continue
			if newPos in visited: continue
				
			visited[pos]=""
			path[newPos] = pos
			stack.append(newPos)
			
	print("Did not find path")
	return []
	

	
	
	
	
# Loading pre-made maps (grids?)
func loadGrid(ID):
	for x in range(2):
		tiles.append([])
		for y in range(height):
			var currentTile = "Tile" + str((x * height) + y)
			var tile = self.get_node(currentTile)
			
			var children = tile.get_children()
			
			tiles[x].append(tile)
	canWin = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
