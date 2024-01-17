extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")
@export var dialogue_resource: DialogueResource
@export var dialogue_start: String = "dash_item"

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	pass

func _on_body_entered(body):
	if(body.name == "Player"):
		body.can_burst = true
		$"../HUD".enable_dash()
		$"../HUD".canDash = true
		var balloon: Node = Balloon.instantiate()
		get_tree().current_scene.add_child(balloon)
		balloon.start(dialogue_resource, dialogue_start)
		queue_free()
