extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "crank_disabled"
@export var portal: Area2D
var enabled = false

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _process(delta):
	pass

func action(body) -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	if(enabled):
		balloon.start(dialogue_resource, "crank_enabled")
	else:
		$Sprite2D.texture = ResourceLoader.load("res://Assets/tiny-RPG-dungeon-files/PNG/environment/objects-sliced/crank-right.png")
		portal.enable_portal()
		enabled = true
		balloon.start(dialogue_resource, dialogue_start)

func _on_area_entered(area):
	if(Save.isKeyboard):
		$PanelContainer/TextureRect.texture = ResourceLoader.load("res://Helpers/keyboard.png")
	else:
		$PanelContainer/TextureRect.texture = ResourceLoader.load("res://Helpers/controller.png")
	$PanelContainer.visible = true

func _on_area_exited(area):
	$PanelContainer.visible = false
