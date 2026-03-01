extends Area2D

func _on_body_entered(body):
	# Check if the thing that touched the spikes is in the "player" group
	if body.is_in_group("player"):
		print("Player died!")
		# OPTIONAL: Play a death sound here if you have one!
		# $AudioStreamPlayer.play() 
		
		# Restart the level instantly
		call_deferred("restart_level")

func restart_level():
	get_tree().reload_current_scene()
