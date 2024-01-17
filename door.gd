extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "door"
var interactable = true
var opened = false

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	pass

func action(body) -> void:
	if(body.key > 0 and opened == false): #matthew 0.1.3.a
		body.key -= 1
		interactable = false
		$PanelContainer.visible = false
		$Sprite2D.region_rect = Rect2(592, 32, 48, 32)
		$StaticBody2D/CollisionClosed.disabled = true
		$StaticBody2D/CollisionOpen.disabled = false
		$StaticBody2D/CollisionOpen2.disabled = false
		opened = true #matthew 0.1.3.a
	elif (opened == false): #matthew 0.1.3.a
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
