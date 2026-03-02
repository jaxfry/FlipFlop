extends Area2D

@export var next_level : PackedScene
@export var delay_seconds : float = 1.5

var is_changing = false

func _on_body_entered(body: Node2D) -> void:
	if not is_changing and (body.name == "Player" or body is CharacterBody2D):
		is_changing = true
		print("Level complete! Waiting...")

		await get_tree().create_timer(delay_seconds).timeout
		
		if next_level:
			change_level()
		else:
			TransitionScreen.change_scene("res://scenes/win_screen.tscn")

func change_level():
	TransitionScreen.change_scene(next_level.resource_path)
