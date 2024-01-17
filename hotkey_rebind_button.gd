class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "left"

func _ready():
	set_process_input(false)
	set_action_name()
	set_text_for_key()

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"left_key":
			label.text= "Move Left"
		"up_key":
			label.text = "Move Up"
		"down_key":
			label.text = "Move Down"
		"right_key":
			label.text = "Move Right"
		"attack_key":
			label.text = "Attack"
		"burst_key":
			label.text = "Dash Button"
		"aim_key":
			label.text = "Aim Button"
		"Accept_key":
			label.text = "Accept Button"
		"escape_key":
			label.text = "Escape Button"
		"pause_key":
			label.text = "Pause Button"
		"action_key":
			label.text = "Interact Button"


func set_text_for_key() -> void:
	var action_events = InputMap.action_get_events(action_name)
	var action_event = action_events[0]
	#var action_keycode OS.get_keycode_string(action_event.as_text())
	var action = action_event.as_text()
	var position = action.find("(Physical)")
	if(position > -1):
		action = action.erase(position, 10) 
	button.text = action

func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key..."
		set_process_input(button_pressed)
		for i in get_tree().get_nodes_in_group("hotkey_button"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_input(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkey_button"):
				if i.action_name != self.action_name:
					i.button.toggle_mode = true
					i.set_process_input(false)
		set_text_for_key()

func _input(event):
	print("unhandled")
	rebind_action_key(event)
	button.button_pressed = false
	

func rebind_action_key(event) -> void:
	if!(event is InputEventMouseMotion):
		InputMap.action_erase_events(action_name)
		InputMap.action_add_event(action_name,event)
		set_text_for_key()
		set_action_name()
		set_process_input(false)
