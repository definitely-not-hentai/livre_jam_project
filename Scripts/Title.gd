extends Node2D

#variavel booleana que diz se deu timeout
var deu_timeout = false
#funcao da variavel de cima
func taimeoute():
	deu_timeout = true

#conecta o timeout do timer e o finished do stream player às respectivas funcoes
func _ready():
	$Timer.connect("timeout",self,"taimeoute")
	$AudioStreamPlayer.connect("finished",self,"loop")
	pass

#da loop no audio
func loop():
	$AudioStreamPlayer.play(0.0)

#muda de cena se já se passou mais de um segundo e se alguma tecla foi apertada
func _input(event):
	if deu_timeout:
		if event is InputEventKey:
			get_tree().change_scene("res://Scenes/Level_1.tscn")