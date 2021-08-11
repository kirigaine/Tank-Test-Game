extends Node2D

func _physics_process(delta):
	# Update debug info
	$DebugInfo/lblPosition.text = "Pos: (%.2f, %.2f)" % [$Player.position.x, $Player.position.y]
	$DebugInfo/lblVelocity.text = "Vel: (%.2f, %.2f)" % [$Player.velocity.x, $Player.velocity.y]
	$DebugInfo/lblRotation.text = "Rot: (%.2f, %.2f)" % [$Player.my_rotation.x, $Player.my_rotation.y]
	
	# Toggle debug info
	if Input.is_action_just_pressed("ui_debug"):
		var children = $DebugInfo.get_children()
		for child in children:
			child.visible = !child.visible
