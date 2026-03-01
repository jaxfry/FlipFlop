extends Node

var gravity_direction = Vector2(0, 1)
var gravity_power = 980.0

func change_gravity(new_dir: Vector2):
	# Only change if it's actually a different direction
	if gravity_direction != new_dir:
		gravity_direction = new_dir

# ==============================================================
# ⚠️  DEV KEYBINDS — REMOVE BEFORE SHIPPING ⚠️
# N  →  skip to next level
# R  →  restart current level
# ==============================================================
const _LEVEL_ORDER = [
	"res://scenes/level_1.tscn",
	"res://scenes/level_2.tscn",
	"res://scenes/level_3.tscn",
	"res://scenes/win_screen.tscn",
]

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		match event.physical_keycode:
			KEY_N:
				_dev_skip_level()
			KEY_R:
				_dev_restart_level()

func _dev_skip_level() -> void:
	var current = get_tree().current_scene.scene_file_path
	var idx = _LEVEL_ORDER.find(current)
	if idx >= 0 and idx < _LEVEL_ORDER.size() - 1:
		TransitionScreen.change_scene(_LEVEL_ORDER[idx + 1])
	else:
		TransitionScreen.change_scene(_LEVEL_ORDER[0])

func _dev_restart_level() -> void:
	var current = get_tree().current_scene.scene_file_path
	TransitionScreen.change_scene(current)
