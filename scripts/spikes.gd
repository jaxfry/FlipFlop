extends Area2D

func _on_body_entered(body):
	# Check if the thing that touched the spikes is in the "player" group
	if body.is_in_group("player"):
		print("Player died!")
		# OPTIONAL: Play a death sound here if you have one!
		# $AudioStreamPlayer.play() 
		
		# Restart the level with a transition
		TransitionScreen.change_scene(get_tree().current_scene.scene_file_path)
