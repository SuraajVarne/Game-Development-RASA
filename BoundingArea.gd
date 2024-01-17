extends Area2D
@export var left = -1000000000
@export var right = 1000000000
@export var up = -1000000000
@export var down = 1000000000
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if(body.name == "Player"):
		body.LeftBound = left
		body.RightBound = right
		body.UpBound = up
		body.DownBound = down
		body.CameraChange()
		
