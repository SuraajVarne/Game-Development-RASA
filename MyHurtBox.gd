extends Area2D

@onready var hitbox = get_node("player.gd")

func _ready():
	hitbox = $CollisionShape2D

func _process(delta):
	if Input.is_action_pressed("ui_accept"):
		if hitbox.collide_with_area(get_parent().get_node("enemy.gd")):
			hitbox -= 10
			pass
