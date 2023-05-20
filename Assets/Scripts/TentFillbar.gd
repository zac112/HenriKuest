extends Light2D

# Called when the node enters the scene tree for the first time.
func _ready():
	scale = Vector2(0,1)


func setScale(percentage:float):
	scale = Vector2(percentage,1)
