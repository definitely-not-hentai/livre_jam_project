extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var player_near = false
var player
var ja_falou = false

const frames = {
	default = 0,
	happy = 1,
	sad = 2,
	angry = 3,
	tired = 4,
	interrogacao = 5,
	candy = 6,
	seta_cima = 7,
	seta_esquerda = 8,
	seta_baixo = 9,
	seta_direita = 10,
	urso_mau = 11,
	urso_fofo = 12,
	cabana = 13,
	cair = 14,
	coracao = 15,
	espada = 16
}
const dialogue_list = ["default","sad","seta_direita","urso_mau","espada"]
var dialogue_index = 0
var is_player_near = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$AudioStreamPlayer2D.connect("finished",self,"audio_finished")
	connect("body_entered",self,"on_body_enter")
	connect("body_exited",self,"on_body_exit")
	pass
	

func audio_finished():
	$AudioStreamPlayer2D.stop()
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_talk") and player_near:
			if player.position.x < position.x:
				$Sprite.flip_h = true
			else:
				$Sprite.flip_h = false
			$Sprite.frame = 0
			if not ja_falou:
				$AudioStreamPlayer2D.play(0.0)
				ja_falou = true
			$Dialogue.frame = frames[dialogue_list[dialogue_index]]
			dialogue_index+=1
			if dialogue_index >= dialogue_list.size():
				dialogue_index = 0
	pass

func on_body_enter(body):
	if body.is_in_group("Player"):
		player = body
		player_near = true
		$Dialogue.frame = frames[dialogue_list[0]]
		dialogue_index = 1
		is_player_near = true
		$Dialogue.show()
	pass
	
func on_body_exit(body):
	if body.is_in_group("Player"):
		player_near = false
		$Dialogue.hide()
	pass
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
