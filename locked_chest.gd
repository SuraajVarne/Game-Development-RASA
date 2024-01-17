extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "chest"
var interactable = true
var opened = false
@export var items: Array
@export var quantities: Array[Vector2]

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	pass

func action(body) -> void:
	if(body.key > 0 and !opened):
		body.key -= 1
		interactable = false
		$PanelContainer.visible = false
		$Sprite2D.texture = ResourceLoader.load("res://Assets/tiny-RPG-dungeon-files/PNG/environment/objects-sliced/big-chest-opened.png")
		generate_items()
		opened = true
	elif(!opened):
		var balloon: Node = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue_start)

func _on_area_entered(area):
	if(Save.isKeyboard):
		$PanelContainer/TextureRect.texture = ResourceLoader.load("res://Helpers/keyboard.png")
	else:
		$PanelContainer/TextureRect.texture = ResourceLoader.load("res://Helpers/controller.png")
	if(interactable):
		$PanelContainer.visible = true

func _on_area_exited(area):
	$PanelContainer.visible = false

func generate_items():
	var radius = 25
	var pos: Vector2 = get_position()
	for i in range(items.size()):
		var numOfItems = randi_range(quantities[i].x, quantities[i]. y)
		for j in range(numOfItems):
			var angle = randf_range(0, 2*PI)
			var x = radius * cos(angle)
			var y = radius * sin(angle)
			var item = items[i].instantiate()
			item.position = Vector2(x, y)
			add_child(item)
