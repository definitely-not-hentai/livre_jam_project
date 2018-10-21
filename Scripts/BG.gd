extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
export(float) var POS_Y = 0
export(float) var MIN_X_PLAYER = -90
export(float) var MAX_X_PLAYER = 6430
export(float) var MIN_X_BG = -600
export(float) var MAX_X_BG = 5290

var player

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	player = get_parent().get_node("Player")
	pass

func _process(delta):
	position.y = POS_Y
	var xis = (player.position.x - MIN_X_PLAYER)/(MAX_X_PLAYER- MIN_X_PLAYER)
	position.x = xis * (MAX_X_BG - MIN_X_BG) + MIN_X_BG
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
