extends Button

var sceneList = ["res://Assets/Scenes/MainMenu.tscn", "res://Assets/Scenes/LevelTutorial.tscn", "res://Assets/Scenes/Level1.tscn", "res://Assets/Scenes/Level2.tscn", "res://Assets/Scenes/Level3.tscn"]


func _ready():
	var currentScene = get_parent().get_parent().get_parent().get_node("GridManager").gridID
	if (currentScene < (len(sceneList) - 1)):
		self.text = "Next Level"
	else:
		self.text = "Play again"
	pass # Replace with function body.

func _pressed():
	var currentScene = get_parent().get_parent().get_parent().get_node("GridManager").gridID
	if (currentScene < (len(sceneList) - 1)):
		get_tree().change_scene(sceneList[currentScene + 1])
	else:
		get_tree().change_scene(sceneList[currentScene])
