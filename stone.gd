extends CharacterBody2D

var speed = 50
var direction = Vector2(0,0)

func _ready():
	$left.body_entered.connect(left_entered)
	$left.body_exited.connect(exited)
	$right.body_entered.connect(right_entered)
	$right.body_exited.connect(exited)
	$top.body_entered.connect(top_entered)
	$top.body_exited.connect(exited)
	$bottom.body_entered.connect(bottom_entered)
	$bottom.body_exited.connect(exited)

func _physics_process(delta):
	move_and_collide(direction)

func left_entered(body):
	if(body.name == "Player"):
		direction = Vector2(0.5,0)

func right_entered(body):
	if(body.name == "Player"):
		direction = Vector2(-0.5,0)

func top_entered(body):
	if(body.name == "Player"):
		direction = Vector2(0,0.5)

func bottom_entered(body):
	if(body.name == "Player"):
		direction = Vector2(0,-0.5)

func exited(body):
	if(body.name == "Player"):
		direction = Vector2(0,0)

func activate():
	$Sprite2D2.visible = true

func deactivate():
	$Sprite2D2.visible = false
