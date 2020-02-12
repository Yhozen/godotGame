extends Node2D


onready var nav2D  = $Navigation2D
onready var character = $KinematicBody2D 
onready var enemies = $Enemies

onready var _timer = Timer.new()
const TIME = 1.0/10

func enemiesFollowPlayer():
	for enemy in enemies.get_children():
		var path = nav2D.get_simple_path(enemy.global_position, character.global_position)
		enemy.path = path
	
func _ready():
	add_child(_timer)
	_timer.connect("timeout", self, "enemiesFollowPlayer")
	_timer.set_wait_time(TIME)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()
