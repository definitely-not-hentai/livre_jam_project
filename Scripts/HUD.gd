extends CanvasLayer

# class member variables go here, for example:
# var a = 2
export(int) var multi = 1

func add_points():
	for i in range (multi):
		$Points.add_text(".")
	$AnimationPlayer.play("Matou")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
