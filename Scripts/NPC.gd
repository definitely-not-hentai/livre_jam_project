extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const frames = {
	default = 0,
	happy = 1,
	sad = 2,
	angry = 3,
	tired = 4
}
const dialogue_list = ["default","sad","angry","happy"]
var dialogue_index = 0
var is_player_near = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	connect("body_entered",self,"on_body_enter")
	connect("body_exited",self,"on_body_exit")
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_talk"):
			$Dialogue.frame = frames[dialogue_list[dialogue_index]]
			dialogue_index+=1
			if dialogue_index >= dialogue_list.size():
				dialogue_index = 0
	pass

func on_body_enter(body):
	if body.is_in_group("Player"):
		$Dialogue.frame = frames[dialogue_list[0]]
		dialogue_index = 1
		is_player_near = true
		$Dialogue.show()
	pass
	
func on_body_exit(body):
	if body.is_in_group("Player"):
		$Dialogue.hide()
	pass
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
