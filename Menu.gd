class_name MainMenu
extends Control

@onready var newgame_button = $"MarginContainer/HBoxContainer/VBoxContainer/New Game" as Button
@onready var options_button =$MarginContainer/HBoxContainer/VBoxContainer/Options as Button
@onready var exit_button = $MarginContainer/HBoxContainer/VBoxContainer/Exit as Button
@onready var margin_container = $MarginContainer as MarginContainer

@onready var loading_screen = preload("res://Helpers/loading_screen.tscn") as PackedScene

func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://Helpers/loading_screen.tscn")

func _on_options_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")

func _on_exit_pressed():
	get_tree().quit()

