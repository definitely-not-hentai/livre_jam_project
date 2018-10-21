extends CanvasLayer

# class member variables go here, for example:
# var a = 2
export(int) var multi = 1
var pontos = 0

func add_points(ganhou):
	if multi <= 0:
		multi = 1
	if ganhou:
		pontos += multi
	else:
		pontos -= 1
	if pontos < 0:
		pontos = 0
	$Points.clear()
	$Points.add_text(str(pontos*100))
	$Points.update()
	if ganhou:
		$AnimationPlayer.play("Matou")
	else:
		$AnimationPlayer.play("Levou")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$AnimationPlayer.connect("animation_finished",self,"acabou")
	pass

func acabou(animacao):
	multi = 1
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
