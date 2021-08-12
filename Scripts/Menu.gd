extends Node2D

# Move player to LEVEL 1
func _on_btnPlay_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")

# Exit game
func _on_btnExit_pressed():
	get_tree().quit()
