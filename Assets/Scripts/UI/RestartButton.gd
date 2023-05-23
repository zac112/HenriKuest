extends Button

var sceneList = ["res://Assets/Scenes/Levels/Intro.tscn", 
"res://Assets/Scenes/Levels/LevelTutorial.tscn", 
"res://Assets/Scenes/Levels/Level1.tscn", 
"res://Assets/Scenes/Levels/Level2.tscn", 
"res://Assets/Scenes/Levels/Level3.tscn", 
"res://Assets/Scenes/Levels/Main.tscn"]


func _ready():
	var currentScene = get_parent().get_parent().get_parent().get_node("GridManager").gridID
	if (currentScene < (len(sceneList) - 1)):
		self.text = "Restart level"
	else:
		self.text = "Play Randomized"
	pass # Replace with function body.

func _pressed():
	var currentScene = get_parent().get_parent().get_parent().get_node("GridManager").gridID
# warning-ignore:return_value_discarded
	get_tree().change_scene(sceneList[currentScene])
