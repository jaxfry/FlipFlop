extends Node

var gravity_direction = Vector2(0, 1)
var gravity_power = 980.0

func change_gravity(new_dir: Vector2):
	# Only change if it's actually a different direction
	if gravity_direction != new_dir:
		gravity_direction = new_dir
