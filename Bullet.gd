extends Area2D

@export var SPEED = 100
func _physics_process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += SPEED * direction * delta

#func _ready(): #matthew 0.1.4
	#area_entered.connect(hit_area)

func destroy():
	queue_free()
	
func _on_body_entered(body):
	if(body.is_in_group("Enemy")): #matthew 0.1.4
		body.get_hit("Bullet")
		destroy()
	elif body.name != "Player":
		destroy()

"""func hit_area(area): #matthew 0.1.4
	if(area.name == "hit_detector"):
		area.hit()"""
