extends CharacterBody2D
@export var health : float = 100
@export var move_speed : float = 100
@export var dash_speed : float = 200
@export var startingposition: Vector2 = Vector2(0,1)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@export var can_burst: bool = false
@export var BurstTime = .5
@onready var canMove: bool = true
@onready var dash = $BurstDash


func _ready():
	#animation_tree.set("parameters/Idle/blend_position", startingposition)
	update_animation_parameters(startingposition)
	
	
#parameters/Idle/blend_position

func _physics_process(_delta):
	var press1 : bool = false
	var press2 : bool = false
	var horizontal
	var vertical
	var speed
	
	horizontal = Input.get_action_strength("right") - Input.get_action_strength("left")
	vertical = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	
	
	if(horizontal == 1 || horizontal == -1):
		press1 = true
	else:
		press1 = false
		
	if (vertical == 1 || vertical == -1):
		press2 = true
	else:
		press2 = false
		
	
	if(press1 && press2):
		vertical = vertical * sqrt(.5)
		horizontal = horizontal * sqrt(.5)
		
	if(Input.is_action_just_pressed("burst") && dash.candash == true && !dash.is_dashing()):
		dash.start_dash(BurstTime)
	if(dash.is_dashing()):
		speed = dash_speed
	else: 
		speed = move_speed
	
	
	var inputDirection = Vector2(
		horizontal,
		vertical
	)
	if(Input.is_action_pressed("aim")):
		canMove = false
	else:
		canMove = true
		
	update_animation_parameters(inputDirection)
	pick_new_state()
	
	print(inputDirection)
	if(canMove == true):
		velocity = inputDirection * speed
	else:
		velocity = inputDirection * 0
	
	move_and_slide()
	

	
		
		
	
	

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/run/blend_position", move_input)

func pick_new_state():
	if(velocity != Vector2.ZERO):
		state_machine.travel("run")
	else:
		state_machine.travel("Idle")

func get_health():
	return health
	
