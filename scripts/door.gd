extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
var is_open = false

# Tracks how many buttons are linked and how many are currently pressed
var registered_buttons := 0
var pressed_buttons := 0

func _ready():
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, true)

func register_button():
	registered_buttons += 1

func button_pressed():
	pressed_buttons += 1
	_update_state()

func button_released():
	pressed_buttons -= 1
	_update_state()

func _update_state():
	if pressed_buttons >= registered_buttons and registered_buttons > 0:
		_open()
	else:
		_close()

func _open():
	if is_open: return
	
	is_open = true
	animated_sprite.play("default")
	CameraShake.add_trauma(0.45)
	
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(2, true)

func _close():
	if not is_open: return
	
	is_open = false
	animated_sprite.play_backwards("default")
	
	set_collision_layer_value(2, false)
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, true)
