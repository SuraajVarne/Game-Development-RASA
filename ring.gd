extends Area2D

@export var stone: CharacterBody2D
var timer = Timer.new()
var ring_extents
var ring_rect
var stone_extents
var stone_rect
var stoneRef
var activated = false
var givekey = true

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)
	timer.set_wait_time(0.5)
	timer.connect("timeout", check_if_enclosed)
	add_child(timer)

func _process(delta):
	pass

func _on_area_entered(object):
	if(object.name == "stone"):
		stoneRef = object
		ring_extents = $CollisionShape2D.shape.extents
		ring_rect = Rect2($CollisionShape2D.global_position - ring_extents, ring_extents * 2)
		timer.start()

func _on_area_exited(object):
	if(object.name == "stone"):
		timer.stop()

func check_if_enclosed():
	stone_extents = stoneRef.get_node("CollisionShape2D").shape.extents
	stone_rect = Rect2(stoneRef.get_node("CollisionShape2D").global_position - stone_extents, stone_extents * 2)
	if(ring_rect.encloses(stone_rect)):
		activate()
	else:
		deactivate()

func activate():
	if(!activated):
		stone.activate()
		$Sprite2D2.visible = true
		$Sprite2D3.visible = true
		$Sprite2D4.visible = true
		activated = true
		if givekey == true:
			var item = load("res://Items/key.tscn")
			var key = item.instantiate()
			key.position = Vector2(0, 10)
			add_child(key)
			givekey = false

func deactivate():
	if(activated):
		stone.deactivate()
		$Sprite2D2.visible = false
		$Sprite2D3.visible = false
		$Sprite2D4.visible = false
		activated = false
