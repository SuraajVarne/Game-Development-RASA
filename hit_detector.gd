extends Area2D

var enabled = true
var givekey = true
func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	pass

func _on_area_entered(area):
	if(enabled && area.name == "Attack1Hitbox" || area.name == "Bullet"):
		if enabled:
			var item = load("res://Items/key.tscn")
			var key = item.instantiate()
			key.position = Vector2(0, 10)
			add_child(key)
			enabled = false
