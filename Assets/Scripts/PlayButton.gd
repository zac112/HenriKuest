extends Button

var sceneList = ["res://Assets/Scenes/TestLevel.tscn", "res://Assets/Scenes/Main.tscn", "res://Assets/Scenes/TestLevel.tscn"]


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
