extends Node

#settings
var isKeyboard = true
#player
var playerSave
var key = 0
var coin = 0
var can_burst = false
var health = 100

func _ready():
	pass

func _process(delta):
	pass

func load_player(player):
	playerSave = player
	player.key = key
	player.coin = coin
	player.can_burst = can_burst
	player.health = health

func save_player():
	key = playerSave.key
	coin = playerSave.coin
	can_burst = playerSave.can_burst
	health = playerSave.health
