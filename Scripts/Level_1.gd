extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const lista_fala_monstro = [["default_bear","happy","coracao"],
							["default_bear","happy","candy","interrogacao"],
							["default_bear","happy","candy","cair"]]
var monster_list = []
var fala_boa = 0

func loop():
	$AudioStreamPlayer.play(0.0)

func _ready():
	$Final.connect("body_entered",self,"on_final")
	$Limite.connect("body_entered",self,"on_limite")
	$Player.connect("add_points",$HUD,"add_points")
	$AudioStreamPlayer.connect("finished",self,"loop")
	for node in get_children():
		if node.is_in_group("Monster"):
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

func on_limite(body):
	if body.is_in_group("Player"):
		print(fala_boa)
		if fala_boa>=3:
			$AnimationPlayer.play("Good_end_anim")
		else:
			$AnimationPlayer.play("Fall_end_anim")

func on_final(body):
	if body.is_in_group("Player"):
		$BG.set_process(false)
		$AnimationPlayer.play("End_anim")
	pass
	
func back():
	get_tree().change_scene("res://Scenes/Level_1.tscn")
	
func next():
	get_tree().change_scene("res://Scenes/Level_2.tscn")
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
