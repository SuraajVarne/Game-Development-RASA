extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "chest"
var interactable = true
var opened = false

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	pass

func action(body) -> void:
	if(!opened):
		interactable = false
		$PanelContainer.visible = false
		$Sprite2D.texture = ResourceLoader.load("res://Assets/tiny-RPG-dungeon-files/PNG/environment/objects-sliced/chest-opened.png")
		generate_items()
		opened = true

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
	var item = load("res://Items/Coin.tscn")
	var radius = 15
	var numOfItems = randi_range(3, 5)
	var pos: Vector2 = get_position()
	for i in range(numOfItems):
		var angle = randf_range(0, 2*PI)
		var x = radius * cos(angle)
		var y = radius * sin(angle)
		var coin = item.instantiate()
		coin.position = Vector2(x, y)
		add_child(coin)
