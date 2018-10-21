extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal falou_bem(node)

const normal = Vector2(0,-1)
export(bool) var FLIP_H = false
export(bool) var WALKING
export(int) var FROM
export(int) var TO

var going_right = true
var vivo = true
var nao_falou = true

export(Vector2) var pos_dialogo = Vector2(0, -195)
export(bool) var agressivo = false
export(int) var GRAVITY = 1000
export(int) var WALK_SPEED = 200
export(int) var JUMP_SPEED = 700
export(float) var ATTACK_DELAY = 1.1

var last = false
var is_attacking = false
var ve_player = false
var player
var can_attack = true
var win = false

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
	espada = 16,
	file = 17,
	folder = 18,
	delete = 19
}
var dialogue_list = ["default_bear","sad","angry","happy"]
var bad_dialogue_list = ["default_bear", "angry"]
var dialogue_index = 1

var linear_velocity = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	$Dialogue.position = pos_dialogo
	add_to_group("Monster")
	$AnimationPlayer.connect("animation_finished",self,"animation_end")
	#$Ataque.connect("body_entered",self,"ataque_entered")
	$AudioStreamPlayer2D.connect("finished",self,"audio_finished")
	$Deteccao.connect("body_entered",self,"player_entered")
	$Deteccao.connect("body_exited",self,"player_exit")
	$Attack_Timer.wait_time = ATTACK_DELAY
	$Attack_Timer.connect("timeout",self,"attack_timeout")
	$Sprite.flip_h = FLIP_H
	if agressivo:
		$Putisse.show()
	pass

func audio_finished():
	$AudioStreamPlayer2D.stop()

func attack_timeout():
	can_attack = true

func player_entered(body):
	if body.is_in_group("Player"):
		ve_player = true
		player = body

func player_exit(body):
	if body.is_in_group("Player"):
		ve_player = false
		dialogue_index = 1
		
func falar():
	if not agressivo:
		if player.position.x > position.x:
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		print("fala normal")
		WALKING = false
		if dialogue_list[dialogue_index] == "default_bear":
			$Dialogue.hide()
		else:
			$Dialogue.show()
			$Dialogue.frame = frames[dialogue_list[dialogue_index]]
		dialogue_index+=1
		if dialogue_index >= dialogue_list.size():
			dialogue_index = 0
		if nao_falou:
			$AudioStreamPlayer2D.play(0.0)
			emit_signal("falou_bem",self)
			nao_falou = false
	else:
		print("fala puto")
		if bad_dialogue_list[dialogue_index] == "default_bear":
			$Dialogue.hide()
		else:
			$Dialogue.show()
			$Dialogue.frame = frames[bad_dialogue_list[dialogue_index]]
		dialogue_index+=1
		if dialogue_index >= bad_dialogue_list.size():
			dialogue_index = 0

func win():
	win = true

func get_puto():
	dialogue_index = 0
	agressivo = true
	WALKING = true
	$Putisse.show()

func animation_end(anim):
	if anim == "Attack":
		is_attacking = false
	pass

func attack():
	if vivo:
		vivo = false
		#rint("ai")
		WALKING = false
		get_parent().fala_boa = 0
		$AnimationPlayer.play("Morrer")
		set_process(false)
		return true
		pass

func _process(delta):
	linear_velocity.x = 0
	if win:
		$Dialogue.frame = frames["candy"]
		$Dialogue.show()
		if is_on_floor():
			linear_velocity.y = -JUMP_SPEED
			pass
	else:
		if WALKING:
			if agressivo and ve_player:
				var distance = player.position - position
				if distance.x < 0:
					$Sprite.flip_h = false
				else:
					$Sprite.flip_h = true
				if player.position.x < TO and player.position.x > FROM:
					if distance.x < -50:
						linear_velocity.x -= WALK_SPEED
					elif distance.x > 50:
						linear_velocity.x += WALK_SPEED
				if distance.x < 60 and distance.x > -60 and can_attack:
					can_attack = false
					$Attack_Timer.start()
					is_attacking = true
					player.attack()
					$AnimationPlayer.play("Attack")
					pass
			else:
				if going_right:
					if position.x < TO:
						linear_velocity.x += WALK_SPEED
						$Sprite.flip_h = true
					else:
						going_right = false
				else:
					if position.x > FROM:
						linear_velocity.x -= WALK_SPEED
						$Sprite.flip_h = false
					else:
						going_right = true
		if ve_player:
			if Input.is_action_just_pressed("ui_talk"):
				falar()
		if is_on_floor() or last:
			linear_velocity.y = 0
			if linear_velocity.x == 0 and not is_attacking:
				$AnimationPlayer.play("Idle")
			elif not is_attacking:
				if $AnimationPlayer.current_animation == "Jump":
					$AnimationPlayer.play("Walking")
					$AnimationPlayer.advance(0.3)
				if $AnimationPlayer.current_animation != "Walking":
					$AnimationPlayer.play("Walking")
		else:
			$AnimationPlayer.play("Jump")
		last = is_on_floor()
	linear_velocity.y += GRAVITY*delta
	move_and_slide(linear_velocity,normal)
	pass