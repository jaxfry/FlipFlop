extends Area2D

func _on_body_entered(body):
	if body.is_in_group("player"):
		TransitionScreen.change_scene(get_tree().current_scene.scene_file_path)
