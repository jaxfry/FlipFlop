extends Area2D

# This allows you to pick a specific door in the Level Editor!
@export var linked_door : StaticBody2D
@onready var sprite = $AnimatedSprite2D

var bodies_on_button = 0

func _on_body_entered(body):
	# Check if it's the Player OR a Box (RigidBody)
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_button += 1
		check_state()

func _on_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_button -= 1
		check_state()

func check_state():
	if linked_door == null:
		return # Prevents crash if you forgot to link a door
		
	if bodies_on_button > 0:
		linked_door.open()
		$AnimatedSprite2D.frame = 1 
	else:
		linked_door.close()
		$AnimatedSprite2D.frame = 0
		
