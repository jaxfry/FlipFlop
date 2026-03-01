extends Area2D

# This allows you to pick a specific door in the Level Editor!
@export var linked_door : StaticBody2D
@onready var sprite = $AnimatedSprite2D

var bodies_on_button = 0
var is_pressed = false

func _ready():
	# Register this button with the linked door so it knows how many buttons it needs
	if linked_door != null:
		linked_door.register_button()

func _on_body_entered(body):
	# Check if it's the Player OR a Box (RigidBody)
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_button += 1
		_check_state()

func _on_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_button -= 1
		_check_state()

func _check_state():
	if linked_door == null:
		return # Prevents crash if you forgot to link a door

	if bodies_on_button > 0 and not is_pressed:
		is_pressed = true
		$AnimatedSprite2D.frame = 1
		linked_door.button_pressed()
	elif bodies_on_button <= 0 and is_pressed:
		is_pressed = false
		$AnimatedSprite2D.frame = 0
		linked_door.button_released()
		
