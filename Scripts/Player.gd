extends KinematicBody2D

const bullet_scene = preload("res://Mini Scenes/Bullet.tscn")
const MAX_SPEED = 10000
const ACCELERATION = 200

export var move_speed = 500
export var rotation_speed = 1

var accelerating = false
var velocity = Vector2.ZERO
var my_rotation = Vector2(0,-1)

func calculate_motion(direction):
	if velocity == Vector2.ZERO:
		velocity = direction * my_rotation * move_speed
	else:
		velocity += direction * my_rotation * ACCELERATION
		velocity = velocity.clamped(MAX_SPEED)
	return velocity
	
func rotate_player(rotati):
	my_rotation.x = cos(fmod(rotation,2*PI)-PI/2)
	my_rotation.y = sin(fmod(rotation,2*PI)-PI/2)
	rotate(rotati)

func _physics_process(delta):
	
	# Move if velocity isn't zero, disable and enable sprite animation and sound
	if velocity != Vector2.ZERO:
		if not $AnimatedSprite.playing:
			$AnimatedSprite.playing = true
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.playing = true
		move_and_slide(velocity * delta).normalized()
	else:
		if $AnimatedSprite.playing:
			$AnimatedSprite.playing = false
		if $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.playing = false
		
	
	# Forward and backwards movement
	if Input.is_action_pressed("ui_up"):
		accelerating = true
		calculate_motion(1)
	elif Input.is_action_pressed("ui_down"):
		accelerating = true
		calculate_motion(-1)
	else:
		accelerating = false
		
	if not accelerating:
		if velocity.x > 1:
			velocity.x -= ACCELERATION
			velocity.x = max(velocity.x, 0)
		else:
			velocity.x += ACCELERATION
			velocity.x = min(velocity.x, 0)
			
		if velocity.y > 1:
			velocity.y -= ACCELERATION
			velocity.y = max(velocity.y, 0)
		else:
			velocity.y += ACCELERATION
			velocity.y = min(velocity.y, 0)
		
	# Left and right rotation
	if Input.is_action_pressed("ui_right"):
		rotate_player(rotation_speed * delta)
	if Input.is_action_pressed("ui_left"):
		rotate_player(-rotation_speed * delta)
	
	# Firing shells
	if Input.is_action_just_pressed("ui_accept"):
		var bullet = bullet_scene.instance()
		bullet.velocity = my_rotation
		bullet.set_position(position)
		get_tree().get_root().add_child(bullet)
