extends Control

# PASTE YOUR LEVEL PATH HERE
# Right-click "Level1.tscn" in FileSystem -> Copy Path -> Paste inside quotes
var level_to_load = "res://scenes/level_1.tscn"



func _on_button_pressed() -> void:
	print("Button Pressed! Loading level...")
	
	# This function deletes 'MainMenu' and loads 'Level1'
	TransitionScreen.change_scene(level_to_load)
