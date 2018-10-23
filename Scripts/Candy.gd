extends KinematicBody2D


#Script do doce do Level 2, basicamente cai

const normal = Vector2(0,-1)
export(int) var GRAVITY = 1000

var linear_velocity = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	if is_on_floor():
		linear_velocity.y = 0
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	linear_velocity.y += GRAVITY*delta
	move_and_slide(linear_velocity,normal)
	pass
