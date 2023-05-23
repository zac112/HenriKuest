extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node(".").visible = false

func _on_GameLogo_visibility_changed():
	get_node(".").visible = true


func _on_Storybutton_pressed():
	get_node("Label2").visible = false
	get_node("Label3").visible = false
	get_node("Victory").visible = false
	
	get_parent().get_node("CanvasLayer/GameLogo").visible = false
	
	get_node("StoryLabel").visible = true
	get_node("Story2").visible = true
	
	
func _on_Story2_pressed():
	get_node("./Label2").visible = true
	get_node("Label3").visible = true
	get_node("Victory").visible = true
	
	get_parent().get_node("CanvasLayer/GameLogo").visible = true
	
	get_node("StoryLabel").visible = false
	get_node("Story2").visible = false
