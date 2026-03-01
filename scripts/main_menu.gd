extends Control

func _input(event):
	# Check if ANY key is pressed or ANY mouse button clicked
	if event is InputEventKey and event.pressed:
		start_game()
	elif event is InputEventMouseButton and event.pressed:
		start_game()
	elif event is InputEventJoypadButton and event.pressed:
		start_game()

func start_game():
	# prevent spamming the input and reloading multiple times
	set_process_input(false)
	
	TransitionScreen.change_scene("res://scenes/level_1.tscn")


var blink_timer = 0.0
func _process(delta):
	blink_timer += delta
	if blink_timer >= 0.5:
		$Label.visible = not $Label.visible
		blink_timer = 0.0
