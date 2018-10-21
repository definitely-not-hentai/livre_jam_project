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

export(bool) var agressivo = false
export(int) var GRAVITY = 800
export(int) var WALK_SPEED = 200
export(int) var JUMP_SPEED = 700
export(float) var ATTACK_DELAY = 1.1
export(AudioStreamSample) var AUDIO_NORMAL
export(AudioStreamSample) var AUDIO_PUTO

var last = false
var is_attacking = false
var ve_player = false
var player
var can_attack = true

var linear_velocity = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("Monster")
	$AnimationPlayer.connect("animation_finished",self,"animation_end")
	#$Ataque.connect("body_entered",self,"ataque_entered")
	$Deteccao.connect("body_entered",self,"player_entered")
	$Deteccao.connect("body_exited",self,"player_exit")
	$Attack_Timer.wait_time = ATTACK_DELAY
	$Attack_Timer.connect("timeout",self,"attack_timeout")
	$Falas.connect("finished",self,"audio_finished")
	$Sprite.flip_h = FLIP_H
	if agressivo:
		$Putisse.show()
	pass

func audio_finished():
	$Falas.stop()

func attack_timeout():
	can_attack = true

func player_entered(body):
	if body.is_in_group("Player"):
		ve_player = true
		player = body

func player_exit(body):
	if body.is_in_group("Player"):
		ve_player = false


func get_puto():
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
			if not agressivo:
				if player.position.x > position.x:
					$Sprite.flip_h = true
				else:
					$Sprite.flip_h = false
				print("fala normal")
				$Falas.stream = AUDIO_NORMAL
				WALKING = false
				$Falas.play(0.0)
				if nao_falou:
					emit_signal("falou_bem",self)
					nao_falou = false
			else:
				print("fala puto")
				$Falas.stream = AUDIO_PUTO
				$Falas.play(0.0)
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
