extends Node2D
@export var dash_delay = 1
var candash = true
@onready var duration_timer = $DurationTimer
@onready var delay_timer = $DelayTimer

func start_dash(duration):
	duration_timer.wait_time = duration
	duration_timer.start()
	
func is_dashing():
	return !duration_timer.is_stopped()
# Called when the node enters the scene tree for the first time.
func end_dash():
	candash = false
	delay_timer.wait_time = dash_delay
	delay_timer.start()
	if(delay_timer.is_stopped()):
		candash = true
	print(candash)

func timeLeft():
	print(duration_timer.time_left)
	return duration_timer.time_left

func _on_duration_timer_timeout():
	if(duration_timer.is_stopped()):
		print("timeout")
	end_dash()
	


func _on_delay_timer_timeout():
	candash = true
	pass # Replace with function body.
