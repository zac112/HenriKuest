extends CanvasLayer




func fade_in(label:Label):
	label.visible = true
	
func fade_out(label:Label):
	label.visible = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func intro():
	var timer = Timer.new()
	timer.wait_time = 0.5
	var label = "Label"
	var labelnumber = 1
	
	
	for _n in range(3):
		var currentLabel = label + String(labelnumber)
		fade_in(get_node(currentLabel))
		yield(get_tree().create_timer(1.5), "timeout")
		fade_out(get_node(currentLabel))
		yield(get_tree().create_timer(1.0), "timeout")
		labelnumber += 1
	get_node("GameLogo").visible = true
	get_node("Control")
	


# Called when the node enters the scene tree for the first time.
func _ready():
	intro()




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Label3_draw():
	get_node("Gamelogo")




