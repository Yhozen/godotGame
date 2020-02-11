extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var nav2D  = $Navigation2D
onready var character = $KinematicBody2D 
onready var enemy = $green_light




func nose():
	var path = nav2D.get_simple_path(enemy.global_position, character.global_position)
	enemy.path = path
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _ready():
	nose()
