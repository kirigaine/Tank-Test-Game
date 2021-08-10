extends KinematicBody2D

export var speed = 60000

var velocity = Vector2.ZERO

func _physics_process(delta):
	move_and_slide(velocity * speed * delta)
	
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
