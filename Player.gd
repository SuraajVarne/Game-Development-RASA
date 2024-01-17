extends CharacterBody2D
@export var move_speed : float = 100
@export var dash_speed : float = 200
@export var startingposition: Vector2 = Vector2(0,1)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@export var can_burst: bool = false
@export var BurstTime = .5
@onready var canMove: bool = true
@onready var dash = $BurstDash
@export var health = 100
@export var attackslide = 50
@export var coin = 0
@export var LeftBound = -1000000000000
@export var RightBound = 1000000000000
@export var UpBound = -1000000000000
@export var DownBound = 1000000000000
var isDialogueOpen: bool = false
var isAiming: bool = false
var attacking : bool = false
var test : bool = true
var inputDirection = Vector2(0,0)
@export var BULLET: PackedScene = preload("res://Projectile/bullet.tscn")
@export var maxHealth = 100
@export var sand = 100
@export var maxSand = 100
@export var key = 0
var passHealDelay = 10
@onready var passHealTimer = $passHealTimer
@onready var enemy = get_node("../Enemy")
@onready var EnemyPosition = enemy.position
@onready var EnemyState = enemy.STATE
@export var knockback_speed : float = -200
@export var isDead = false

func _ready():
	#animation_tree.set("parameters/Idle/blend_position", startingposition)
	update_animation_parameters(startingposition)
	DialogueManager.dialogue_ended.connect(dialogueClosed)
	DialogueManager.got_dialogue.connect(dialogueOpened)
	passHealTimer.wait_time = passHealDelay
	Save.load_player(self)
	
#parameters/Idle/blend_position

func dialogueClosed(resouce: DialogueResource):
	isDialogueOpen = false

func dialogueOpened(line: DialogueLine):
	isDialogueOpen = true

func _physics_process(_delta):
	var press1 : bool = false
	var press2 : bool = false
	var horizontal
	var vertical
	var speed
	var currentdash : bool = false
	EnemyState = enemy.STATE
	
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
		
	if(Input.is_action_just_pressed("burst") && dash.candash == true && !dash.is_dashing() && canMove == true && can_burst):
		dash.start_dash(BurstTime)
		currentdash = true
		shoot_bullet()
	if(EnemyState == "Attack"):
		speed = knockback_speed
	elif(attacking):
		speed = attackslide
	elif(dash.is_dashing()):
		speed = dash_speed
		dash.timeLeft()
		set_collision_mask_value(4, false)
	else: 
		speed = move_speed
		set_collision_mask_value(4, true)

	if(Input.is_action_pressed("escape")):
		get_tree().change_scene_to_file("res://Menu.tscn")
	
	#if(!dash.is_dashing() && currentdash):
	if(dash.duration_timer.is_stopped() == false && currentdash == true):
		currentdash = false
		dash.end_dash()
		print("currentdash")
		#get_tree().change_scene_to_file("res://Menu.tscn")
	
	inputDirection = Vector2(
		horizontal,
		vertical
	)
	
	if(Input.is_action_pressed("aim")):
		isAiming = true
		#canMove = false
	else:
		isAiming = false
		#canMove = true
	
	if(isAiming || isDialogueOpen):
		canMove = false
	else:
		canMove = true
	if isAiming:
		if Input.is_action_just_pressed("burst") && can_burst:
			shoot_bullet()
		
	update_animation_parameters(inputDirection)
	#if(attacking == false):
	pick_new_state()
	
	#print(inputDirection)
	if(canMove == true):
		velocity = inputDirection * speed
	else:
		velocity = inputDirection * 0
	
	move_and_slide()
	
	if (passHealTimer.is_stopped()):
		heal_player(1)

func shoot_bullet():
	if BULLET:
		var bullet = BULLET.instantiate()
		var bullet_rotation = inputDirection.angle()
		var bulletDirection = inputDirection
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = self.global_position
		if !Input.is_action_pressed("aim"):
			bulletDirection.y = -bulletDirection.y
			bulletDirection.x = -bulletDirection.x
			bullet_rotation = bulletDirection.angle()
	
			
		bullet.rotation = bullet_rotation
	

func update_animation_parameters(move_input: Vector2):
	if(move_input != Vector2.ZERO):
		var move = move_input
		animation_tree.set("parameters/Idle/blend_position", move_input)
		animation_tree.set("parameters/run/blend_position", move_input)
		animation_tree.set("parameters/Dash/blend_position", move_input)
		animation_tree.set("parameters/Attack1/blend_position", move_input)

func pick_new_state():
	if(Input.is_action_just_pressed("attack")):
		attacking = true
		state_machine.travel("Attack1")
		print("attack")
		$Attack1Timer.start()
		
	if(attacking == false):
		if(velocity != Vector2.ZERO):
			if dash.is_dashing():
				state_machine.travel("Dash")
			else:
				state_machine.travel("run")
		else:
			state_machine.travel("Idle")
			print("Idle")


#for dialogue
@onready var actionable_finder: Area2D = $Direction/ActionableFinder
func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("action"):
		var actionables = actionable_finder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action($".")
			return

func _input(event):
	if(event is InputEventKey):
		Save.isKeyboard = true
	elif(event is InputEventJoypadMotion or event is InputEventJoypadButton):
		Save.isKeyboard = false

func take_damage(dmg):
	health -= min(health, dmg)
	passHealTimer.start()

func heal_player(amnt):
	health = min(maxHealth, health + amnt)

func _on_attack_1_timer_timeout():
	attacking = false
	state_machine.travel("Idle")
	print("end")

func CameraChange():
	$Camera2D.limit_bottom = DownBound
	$Camera2D.limit_top = UpBound
	$Camera2D.limit_right = RightBound
	$Camera2D.limit_left = LeftBound

func die():
	if health <= 0 and not isDead:
		isDead = true
		get_tree().change_scene_to_file("res://game_over.tscn")


func _on_attack_1_hitbox_body_entered(body):
	if(body.is_in_group("Enemy")):
		body.get_hit("attack1hitbox")
