extends Node

var gravity_direction = Vector2(0, 1)
var gravity_power = 980.0

func change_gravity(new_dir: Vector2):
	# Only change if it's actually a different direction
	if gravity_direction != new_dir:
		gravity_direction = new_dir
		CameraShake.add_trauma(0.6)

# ==============================================================
# ⚠️  DEV KEYBINDS — REMOVE BEFORE SHIPPING ⚠️
# N  →  skip to next level
# R  →  restart current level
# ==============================================================
func _get_level_order() -> Array:
	var levels: Array = []
	var dir = DirAccess.open("res://scenes")
	if dir:
		dir.list_dir_begin()
		var file = dir.get_next()
		while file != "":
			if not dir.current_is_dir() and file.begins_with("level_") and file.ends_with(".tscn"):
				levels.append("res://scenes/" + file)
			file = dir.get_next()
		dir.list_dir_end()
	levels.sort()
	levels.append("res://scenes/win_screen.tscn")
	return levels

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_N:
				_dev_skip_level()
			KEY_R:
				_dev_restart_level()

func _dev_skip_level() -> void:
	var level_order = _get_level_order()
	var current = get_tree().current_scene.scene_file_path
	var idx = level_order.find(current)
	if idx >= 0 and idx < level_order.size() - 1:
		TransitionScreen.change_scene(level_order[idx + 1])
	else:
		TransitionScreen.change_scene(level_order[0])

func _dev_restart_level() -> void:
	var current = get_tree().current_scene.scene_file_path
	TransitionScreen.change_scene(current)
