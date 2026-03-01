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
var parallax_offset = Vector2.ZERO
const PARALLAX_STRENGTH = 30.0
const PARALLAX_SMOOTH = 3.0

func _process(delta):
	blink_timer += delta
	if blink_timer >= 0.5:
		$Label.visible = not $Label.visible
		blink_timer = 0.0
	
	# Mouse parallax
	var viewport_size = get_viewport_rect().size
	var mouse_pos = get_viewport().get_mouse_position()
	var center = viewport_size / 2.0
	var target_offset = (mouse_pos - center) / center * PARALLAX_STRENGTH
	parallax_offset = parallax_offset.lerp(target_offset, PARALLAX_SMOOTH * delta)
	$ParallaxBackground.scroll_offset = parallax_offset
