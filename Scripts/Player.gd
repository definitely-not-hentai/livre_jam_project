extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
signal add_points(ganhou)

const normal = Vector2(0,-1)
export(int) var GRAVITY = 1000
export(int) var WALK_SPEED = 300
export(int) var JUMP_SPEED = 700
export(bool) var can_attack = true

var last = false
var is_attacking = false
var body_list = []
var inocente = true

var linear_velocity = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("Player")
	$AnimationPlayer.connect("animation_finished",self,"animation_end")
	$Ataque.connect("body_entered",self,"corpo_entrou")
	$Ataque.connect("body_exited",self,"corpo_saiu")
	pass

func corpo_saiu(body):
	if body in body_list:
		body_list.erase(body)
	pass
	
func fix_camera():
	var camera = $Camera2D
	remove_child(camera)
	camera.position += position
	get_parent().add_child(camera)

func corpo_entrou(body):
	if not body in body_list:
		body_list.append(body)
	pass
	
func attack():
	print("aiaiai")
	emit_signal("add_points",false)

func animation_end(anim):
	if anim == "Attack":
		is_attacking = false
		$Sprite.position.x = -1.5
	pass

func _process(delta):
	linear_velocity.x = 0
	if Input.is_action_just_pressed("ui_attack") and not is_attacking and can_attack:
		$AnimationPlayer.play("Attack")
		if $Sprite.flip_h:
			$Sprite.position.x = -22
		else:
			$Sprite.position.x = 20
		is_attacking = true
	if is_attacking:
		for body in body_list:
			#print(body.name)
			if body.is_in_group("Monster"):
				if body.attack() == true:
					emit_signal("add_points",true)
					if inocente:
						inocente = false
						for node in get_parent().get_children():
							if node.is_in_group("Monster"):
								node.get_puto()
	if Input.is_action_pressed("ui_right"):
		linear_velocity.x += WALK_SPEED
		$Sprite.flip_h = false
		$Ataque.position.x = 70
	if Input.is_action_pressed("ui_left"):
		linear_velocity.x -= WALK_SPEED
		$Sprite.flip_h = true
		$Ataque.position.x = 20
	if is_on_floor() or last:
		linear_velocity.y = 0
		if linear_velocity.x == 0 and not is_attacking:
			$AnimationPlayer.play("Idle")
		elif not is_attacking:
			if $AnimationPlayer.current_animation == "Jump":
				$AnimationPlayer.play("Walking")
			elif $AnimationPlayer.current_animation != "Walking":
				$AnimationPlayer.play("Walking")
				$AnimationPlayer.advance(0.15)
		if Input.is_action_pressed("ui_up"):
			linear_velocity.y -= JUMP_SPEED
	elif is_on_ceiling():
		linear_velocity.y += GRAVITY*delta
	elif not is_attacking:
		$AnimationPlayer.play("Jump")
	last = is_on_floor()
	linear_velocity.y += GRAVITY*delta
	move_and_slide(linear_velocity,normal)
	pass
