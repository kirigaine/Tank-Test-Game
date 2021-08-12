extends KinematicBody2D

const bullet_scene = preload("res://Mini Scenes/Bullet.tscn")
const MAX_SPEED = 10000
const ACCELERATION = 200

export var move_speed = 500
export var rotation_speed = 1

var accelerating = false
var shell_loaded = true
var mg_loaded = true
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
	
	# Rotate head of tank to mouse position
	$Pivot.rotation = get_angle_to(get_global_mouse_position()) + PI/2
	
	# Move if velocity isn't zero, disable and enable sprite animation and sound
	if velocity != Vector2.ZERO:
		if not $sprTankBody.playing:
			$sprTankBody.playing = true
		if not $AudioStreamPlayer2D.playing:
			$AudioStreamPlayer2D.playing = true
		move_and_slide(velocity * delta).normalized()
	else:
		if $sprTankBody.playing:
			$sprTankBody.playing = false
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
		if Input.is_action_pressed("ui_down"):
			rotate_player(-rotation_speed * delta)
		else:
			rotate_player(rotation_speed * delta)
	if Input.is_action_pressed("ui_left"):
		if Input.is_action_pressed("ui_down"):
			rotate_player(rotation_speed * delta)
		else:
			rotate_player(-rotation_speed * delta)
			
	# Firing shells
	if Input.is_action_just_pressed("ui_primary"):
		if shell_loaded:
			shell_loaded = false
			$tmrPrimary.start()
			var bullet = bullet_scene.instance()
			bullet.velocity.x = cos($Pivot.rotation + rotation - PI/2)
			bullet.velocity.y = sin($Pivot.rotation + rotation - PI/2)
			bullet.set_position($Pivot/muzzleEnd.global_position)
			get_tree().get_root().add_child(bullet)
	# Firing machine gun
	elif Input.is_action_pressed("ui_secondary"):
		if mg_loaded:
			mg_loaded = false
			$tmrSecondary.start()
			var bullet = bullet_scene.instance()
			bullet.velocity.x = cos($Pivot.rotation + rotation - PI/2)
			bullet.velocity.y = sin($Pivot.rotation + rotation - PI/2)
			bullet.set_position($Pivot/muzzleEnd.global_position)
			get_tree().get_root().add_child(bullet)

# On timer end, allow another primary shot
func _on_tmrPrimary_timeout():
	shell_loaded = true

# On timer end, allow another secondary shot
func _on_tmrSecondary_timeout():
	mg_loaded = true
