extends Node2D

const tile_path = preload("res://Assets/Scenes/WorldGen/Tile.tscn")
const leftup = preload("res://Assets/Sprites/Grid sprites/1.png")
const leftdown = preload("res://Assets/Sprites/Grid sprites/3.png")
const rightup = preload("res://Assets/Sprites/Grid sprites/2.png")
const rightdown = preload("res://Assets/Sprites/Grid sprites/4.png")

const tent = preload("res://Assets/Scenes/TentScenes/Tent.tscn")
const tent2 = preload("res://Assets/Scenes/TentScenes/Tent2.tscn")
const tent3 = preload("res://Assets/Scenes/TentScenes/Tent3.tscn")
const tent4 = preload("res://Assets/Scenes/TentScenes/Tent4.tscn")
const tent_destroyed = preload("res://Assets/Scenes/TentScenes/Tent_destroyed.tscn")


var tiles = [[]]
var tents 
var obstaclePositions = []
var obstacles = [preload("res://Assets/Scenes/Obstacles/Obstacle.tscn"),
preload("res://Assets/Scenes/Obstacles/Obstacle2.tscn")]

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
	if gridID == 0:
		#print("GRIDID: ", gridID)
		self.visible = false
	else:
		get_parent().get_node("Control").get_node("Victory").visible = false
		get_parent().get_node("Control").get_node("Loss").visible = false
		# get_parent().get_node("Control").visible = false
	tents = [tent,tent2,tent3,tent4,tent_destroyed]
	if gridID == 0:
		pass
	elif (gridID < 5):
		loadGrid()
	else:
		generateGrid()
	
func has_village(x,y):
	if x >= width or y >= height or x < 0 or y < 0:
		return false
	var tile = tiles[x][y]
	var children = tile.get_children()
	if len(children) < 2:
		return false
	return children[1].is_in_group("Tents")
	
func no_near_tents(x, y):
	return !has_village(x-1, y) and !has_village(x-1,y-1) and !has_village(x-1,y+1) and !has_village(x,y-1)
	
func generateGrid():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for x in range(width):
		tiles.append([])
		for y in range(height):
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
			
			
			if rng.randi_range(0,100) < 5 and no_near_tents(x,y):
				spawnTent(tile, rng.randi_range(0,len(tents)-1))
			elif rng.randi_range(0,10) < 2:
				tile.addContent(obstacles[rng.randi_range(0,len(obstacles)-1)].instance())
				obstaclePositions.append(Vector2(x,y))
			

			tiles[x].append(tile)
	canWin = true

func getGridID():
	return gridID

func victory():
	self.visible = false
	get_parent().get_node("Player").visible = false
	get_parent().get_node("Control").visible = true
	get_parent().get_node("Control").get_node("Loss").visible = false
	get_parent().get_node("Control").get_node("Victory").visible = true
	if gridID == 1:
		get_parent().get_node("Control").get_node("TutorialText").visible = false
		get_parent().get_node("Control").get_node("TutorialText2").visible = false
	# get_tree().change_scene("res://Assets/Scenes/winScreen.tscn")

func loss():
	self.visible = false
	get_parent().get_node("Player").visible = false
	get_parent().get_node("Control").visible = true
	get_parent().get_node("Control").get_node("Victory").visible = false
	get_parent().get_node("Control").get_node("Loss").visible = true
	if gridID == 1:
		get_parent().get_node("Control").get_node("TutorialText").visible = false
		get_parent().get_node("Control").get_node("TutorialText2").visible = false

	
func spawnTent(tile, number):
	if(number == 0):
		if(not($Audio == null)):
			$Audio.play()
			$Audio.stop()
	if number == 0:
		playerTents+=1
	if number != 4:
		spawnedTentsCount+=1
	#print("Player: " + str(playerTents) + " Total: " + str(spawnedTentsCount))
	if (playerTents == 0 and canWin):
		#print("loss")
		canWin = false
		loss()
	elif (playerTents >= spawnedTentsCount and canWin):
		#print("victory")
		canWin = false
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
						result.append(fromPos)
						break
								
			result.pop_back() #remove null at end
			result.invert()
			for _i in range(len(result)):
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
func loadGrid():
	for x in range(width):
		tiles.append([])
		for y in range(height):
			var currentTile = "Tile" + str((x * height) + y)
			var tile = self.get_node(currentTile)
			
			var children = tile.get_children()
			if (len(children) > 1):
				if (children[1].is_in_group("PlayerTents")):
					playerTents += 1
				
				if (children[1].is_in_group("Tents")):
					spawnedTentsCount += 1
					
				if (children[1].is_in_group("Obstacle")):
					obstaclePositions.append(Vector2(x,y))
					
			tiles[x].append(tile)
	canWin = true
