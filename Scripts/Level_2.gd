extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const fala_chefe = ["default_bear","candy","seta_cima","folder","file","delete","candy"]
const lista_fala_monstro = [["default_bear","sad","candy","coracao"],
							["default_bear","candy","coracao","candy","coracao"],
							["default_bear","candy","seta_direita","cabana","urso_fofo"]]
var monster_list = []

var fala_boa = 0
var body_fora = false
var body_dentro = false

const pos_fora = Vector2(3436,528)
const pos_dentro = Vector2(1942,2731)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Cabana_chefe.connect("body_entered",self,"body_entrou_fora_cabana")
	$Cabana_chefe.connect("body_exited",self,"body_saiu_fora_cabana")
	$Porta.connect("body_entered",self,"body_entrou_dentro_cabana")
	$Porta.connect("body_exited",self,"body_saiu_dentro_cabana")
	var file = File.new()
	file.open("res://CANDY_CAGE.gd", File.WRITE)
	file.close()
	for node in get_children():
		if node.is_in_group("Monster"):
			if node.name == "Chefe":
				node.dialogue_list = fala_chefe
			else:
				monster_list.append(node)
				node.connect("falou_bem", self, "on_falou_bem")
				node.dialogue_list = lista_fala_monstro[0]
			pass
	pass

func on_falou_bem(node):
	fala_boa+=1
	if fala_boa < 3:
		monster_list.erase(node)
		for child in monster_list:
			child.dialogue_list = lista_fala_monstro[fala_boa]
			pass
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
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	pass


func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_FOCUS_IN:
		var file = File.new()
		if not file.file_exists("res://CANDY_CAGE.gd"):
			if $Plataforma:
				$Plataforma.queue_free()
				for node in get_children():
					if node.is_in_group("Monster"):
						node.win()
						$AnimationPlayer.play("Win")
	elif what == MainLoop.NOTIFICATION_WM_FOCUS_OUT:
		pass

func finish():
	get_tree().change_scene("res://Scenes/Title.tscn")