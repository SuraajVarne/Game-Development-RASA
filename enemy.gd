extends CharacterBody2D
# Script by Joey Mahan

@export var SPEED = 50.0
@export var STATE = "Idle"
@export var HEALTH = 50
@export var startingposition: Vector2 = Vector2(-151,-109)
@onready var animation_tree = $AnimationTree
@onready var state_machine = animation_tree.get("parameters/playback")
@onready var player = get_node("../Player")
@onready var PlayerHealth = player.health
@onready var PlayerPosition = player.position
var player_left = true #matthew 0.1.4
@onready var stun_timer = $"stun timer" #matthew 0.1.4
@onready var knockback_timer = $"kockback timer" #matthew 0.1.4
@onready var attack_timer = $"attack timer" #matthew 0.1.4

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	velocity = global_position.direction_to(PlayerPosition) * 0
	update_animation_parameters()
	$AttackArea.body_exited.connect(_on_attack_area_body_exited) #matthew 0.1.4
	attack_timer.timeout.connect(hit_player) #matthew 0.1.4

func _physics_process(_delta):
	# Get player's position
	PlayerPosition = player.position
	
	# Set speed and direction
	if(STATE == "Chase"):
		# Make enemy chase player
		velocity = global_position.direction_to(PlayerPosition) * SPEED
	elif(STATE == "knockback"): #matthew 0.1.4
		# Knockback
		velocity = global_position.direction_to(PlayerPosition) * -100
		if(knockback_timer.is_stopped()):
			STATE = "stunned"
		stun_timer.start()
	elif(STATE == "stunned"): #matthew 0.1.4
		velocity = global_position.direction_to(PlayerPosition) * 0
		if(stun_timer.is_stopped()):
			STATE = "idle"
	else:
		# Make enemy stand still
		velocity = global_position.direction_to(PlayerPosition) * 0
		if(!player_left): #matthew 0.1.4
			STATE = "Chase"
	
	# Move enemy
	move_and_slide()
	update_animation_parameters()


func _on_detection_range_body_entered(body):
	# Puts enemy into "chase mode"
	if(body.name == "Player"):
		player_left = false #matthew 0.1.4
		STATE = "Chase"


func _on_attack_area_body_entered(body):
	if(body.name == "Player"):
		# Damage player upon contact
		player.take_damage(5)
		attack_timer.start() #matthew 0.1.4
		
		# Puts enemy in "attack mode"
		STATE = "Attack"

func update_animation_parameters():
	# Change animation
	if(STATE == "Chase"):
		animation_tree.set("parameters/run/blend_position", global_position.direction_to(PlayerPosition))
		state_machine.travel("run")
	else:
		state_machine.travel("idle")


func _on_detection_range_body_exited(body):
	# Puts enemy out of "chase mode"
	if(body.name == "Player"):
		player_left = true #matthew 0.1.4
		STATE = "Idle"

func _on_attack_area_body_exited(body): #matthew 0.1.4
	if(body.name == "Player"):
		attack_timer.stop()

func get_hit(type): #matthew 0.1.4
	if(type == "Attack1Hitbox"):
		take_damage(10)
		STATE = "knockback"
		knockback_timer.start()
	if(type == "Bullet"):
		take_damage(5)

func hit_player(): #matthew 0.1.4
	player.take_damage(5)

func take_damage(dmg): #matthew 0.1.4
	HEALTH -= min(HEALTH, dmg)
	if(HEALTH == 0):
		queue_free()
