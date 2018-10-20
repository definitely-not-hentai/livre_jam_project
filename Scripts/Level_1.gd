extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	$Final.connect("body_entered",self,"on_body_enter")
	pass

func on_body_enter(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("End_anim")
	pass
	
func back():
	get_tree().change_scene("res://Scenes/Level_1.tscn")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass