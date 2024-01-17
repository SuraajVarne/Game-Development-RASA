extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String
@export var togglable: bool = false
var enabled = true

func _ready():
	area_entered.connect(_on_area_entered)

func _process(delta):
	pass

func _on_area_entered(area):
	if(togglable):
		if(enabled):
			var balloon: Node = Balloon.instantiate()
			get_tree().current_scene.add_child(balloon)
			balloon.start(dialogue_resource, dialogue_start)
			enabled = false
	else:
		var balloon: Node = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue_start)
