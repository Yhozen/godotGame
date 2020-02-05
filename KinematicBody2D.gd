extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# constants
const FLOOR_NORMAL = Vector2(0,-1)
const GRAVITY = 50
const POWER_JUMP = 800

export (int) var speed = 80
var velocity = Vector2()

func get_input():
	if Input.is_action_pressed('ui_right'):
		velocity.x += speed
	elif Input.is_action_pressed('ui_left'):
		velocity.x -= speed
	else:
		velocity.x = 0
		
	if Input.is_action_pressed('ui_up') and is_on_floor():
		velocity.y -= POWER_JUMP
		
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR_NORMAL)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	get_input()

