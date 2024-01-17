extends Control



func _on_retry_pressed():
	get_tree().change_scene_to_file("res://Levels/node_2d.tscn")
	#will be updated to load save when save implemented


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://Menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
