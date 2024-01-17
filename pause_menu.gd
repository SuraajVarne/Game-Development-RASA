extends Control

var _is_paused:bool = false:
	set = set_paused
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		self._is_paused = !_is_paused
		$"../../../HUD".visible = !_is_paused


func set_paused(value:bool) ->void:
	_is_paused = value
	get_tree().paused = _is_paused
	visible = _is_paused
	

func _on_resume_btn_pressed():
	_is_paused = false 
	$"../../../HUD".visible = true

func _on_save_btn_pressed():
	# Global.position = $Player.position
	# Global.save_data()
	pass # Replace with function body.


func _on_quit_btn_pressed():
	get_tree().quit()
	# get_tree().change_scene_to_file("res://menu.tscn")
