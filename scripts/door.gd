extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
var is_open = false

# Tracks how many buttons are linked and how many are currently pressed
var registered_buttons := 0
var pressed_buttons := 0

func _ready():
	# SETUP: Ensure the door exists on both World and Box layers initially
	set_collision_layer_value(1, true) # Layer 1: World (Player hits this)
	set_collision_layer_value(3, true) # Layer 3: Box (Box hits this)

# Called by each FloorButton in _ready() so the door knows how many buttons it needs
func register_button():
	registered_buttons += 1

# Called by a FloorButton when something steps on it
func button_pressed():
	pressed_buttons += 1
	_update_state()

# Called by a FloorButton when everything steps off it
func button_released():
	pressed_buttons -= 1
	_update_state()

func _update_state():
	# Open only when ALL linked buttons are pressed
	if pressed_buttons >= registered_buttons and registered_buttons > 0:
		_open()
	else:
		_close()

func _open():
	if is_open: return
	
	is_open = true
	animated_sprite.play("default")
	CameraShake.add_trauma(0.45)
	
	# Switch to layer 2 only.
	# Player mask = layers 1 & 3 → does NOT scan layer 2 → passes through.
	# Box mask    = layers 1, 2 & 3 → DOES scan layer 2 → still blocked.
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(2, true)

func _close():
	if not is_open: return
	
	is_open = false
	animated_sprite.play_backwards("default")
	
	# Restore layers 1 & 3; remove layer 2.
	set_collision_layer_value(2, false)
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, true)
