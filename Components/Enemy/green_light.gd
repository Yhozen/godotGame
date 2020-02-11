extends Light2D

var speed = 400
var path = PoolVector2Array() setget set_path

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	pass # Replace with function body.

func set_path(value):
	path = value
	if value.size() == 0:
		return
	set_process(true)
	
func move_along_path(distance):
	var startPoint = position
	for i in range(path.size()):
		var distanceToNext = startPoint.distance_to(path[0])
		if distance <= distanceToNext and distance >= 0:
			position = startPoint.linear_interpolate(path[0], distance/ distanceToNext)
			break
		elif distance < 0:
			position=path[0]
			set_process(false)
		distance -= distanceToNext
		startPoint=path[0]
		path.remove(0)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var moveDistance = speed * delta
	move_along_path(moveDistance)
	pass
