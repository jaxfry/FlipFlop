extends Node

var gravity_direction = Vector2(0, 1)
var gravity_power = 980.0

func change_gravity(new_dir: Vector2):
	if gravity_direction != new_dir:
		gravity_direction = new_dir
		CameraShake.add_trauma(0.6)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.physical_keycode == KEY_R:
			var current = get_tree().current_scene.scene_file_path
			TransitionScreen.change_scene(current)
