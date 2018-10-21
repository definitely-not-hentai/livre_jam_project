extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var deu_timeout = false

func taimeoute():
	deu_timeout = true

func _ready():
	$Timer.connect("timeout",self,"taimeoute")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _input(event):
	if deu_timeout:
		if event is InputEventKey:
			get_tree().change_scene("res://Scenes/Level_1.tscn")