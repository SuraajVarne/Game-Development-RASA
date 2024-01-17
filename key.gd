extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	pass

func _on_body_entered(body):
	if(body.name == "Player"):
		body.key += 1
		queue_free()
