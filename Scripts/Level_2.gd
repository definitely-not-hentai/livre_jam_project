extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var fala_boa = 0
var body_fora = false
var body_dentro = false

const pos_fora = Vector2(3436,528)
const pos_dentro = Vector2(1942,2575)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Cabana_chefe.connect("body_entered",self,"body_entrou_fora_cabana")
	$Cabana_chefe.connect("body_exited",self,"body_saiu_fora_cabana")
	$Porta.connect("body_entered",self,"body_entrou_dentro_cabana")
	$Porta.connect("body_exited",self,"body_saiu_dentro_cabana")
	var file = File.new()
	file.open("res://Plataforma.gd", File.WRITE)
	file.close()
	pass

func body_entrou_fora_cabana(body):
	if body.is_in_group("Player"):
		body_fora = true
	pass
	
func body_saiu_fora_cabana(body):
	if body.is_in_group("Player"):
		body_fora = false
	pass
	
func body_entrou_dentro_cabana(body):
	if body.is_in_group("Player"):
		body_dentro = true
	pass
	
func body_saiu_dentro_cabana(body):
	if body.is_in_group("Player"):
		body_dentro = false
	pass
	
func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_talk"):
			if body_fora:
				$Player.position = pos_dentro
			elif body_dentro:
				$Player.position = pos_fora
	pass
func _process(delta):
	var file = File.new()
	if not file.file_exists("res://Plataforma.gd"):
		$Plataforma.queue_free()
		set_process(false)
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass
