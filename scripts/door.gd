extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
var is_open = false

func _ready():
	# SETUP: Ensure the door exists on both World and Box layers initially
	set_collision_layer_value(1, true) # Layer 1: World (Player hits this)
	set_collision_layer_value(3, true) # Layer 3: Box (Box hits this)

func open():
	if is_open: return
	
	is_open = true
	animated_sprite.play("default")
	
	# Switch to layer 2 only.
	# Player mask = layers 1 & 3 → does NOT scan layer 2 → passes through.
	# Box mask    = layers 1, 2 & 3 → DOES scan layer 2 → still blocked.
	set_collision_layer_value(1, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(2, true)

func close():
	if not is_open: return
	
	is_open = false
	animated_sprite.play_backwards("default")
	
	# Restore layers 1 & 3; remove layer 2.
	set_collision_layer_value(2, false)
	set_collision_layer_value(1, true)
	set_collision_layer_value(3, true)
