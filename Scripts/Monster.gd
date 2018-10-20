extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const normal = Vector2(0,-1)

export(int) var FROM
export(int) var TO

var going_right = true

export(int) var GRAVITY = 600
export(int) var WALK_SPEED = 200
export(int) var JUMP_SPEED = 700

var last = false
var is_attacking = false

var linear_velocity = Vector2(0,0)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	add_to_group("Monster")
	$AnimationPlayer.connect("animation_finished",self,"animation_end")
	$Ataque.connect("body_entered",self,"ataque_entered")
	pass

func ataque_entered(body):
	if is_attacking and body.is_in_group("Player"):
		body.attack()
		pass
	pass

func animation_end(anim):
	if anim == "Attack":
		is_attacking = false
	pass
	
func attack():
	print("ai")
	pass

func _process(delta):
	linear_velocity.x = 0
	if going_right:
		if position.x < TO:
			linear_velocity.x += WALK_SPEED
		else:
			going_right = false
	else:
		if position.x > FROM:
			linear_velocity.x -= WALK_SPEED
		else:
			going_right = true
	if linear_velocity.x > 0:
		$Sprite.flip_h = false
	if linear_velocity.x < 0:
		$Sprite.flip_h = true
	if is_on_floor() or last:
		linear_velocity.y = 0
		if linear_velocity.x == 0 and not is_attacking:
			$AnimationPlayer.play("Idle")
		elif not is_attacking:
			if $AnimationPlayer.current_animation != "Walking":
				$AnimationPlayer.play("Walking")
	else:
		$AnimationPlayer.play("Jump")
	last = is_on_floor()
	linear_velocity.y += GRAVITY*delta
	move_and_slide(linear_velocity,normal)
	pass
