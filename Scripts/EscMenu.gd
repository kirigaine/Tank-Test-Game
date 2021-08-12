extends CanvasLayer

# Exit to menu
func _on_btnMenu_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")

# Exit to desktop
func _on_btnExit_pressed():
	get_tree().quit()
