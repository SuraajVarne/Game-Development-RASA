class_name OptionsMenu
extends Control

@onready var Exit = $MarginContainer/VBoxContainer/Exit as Button

func _on_exit_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")
