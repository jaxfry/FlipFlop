extends RigidBody2D

var is_held = false

func _physics_process(delta):
	# If held, DO NOTHING. Let the player move us.
	if is_held:
		return

	# If NOT held, apply custom gravity as normal
	# (Note: We use the damping trick from before)
	var force = GameManager.gravity_direction * GameManager.gravity_power * mass
	apply_central_force(force)

func pick_up():
	is_held = true
	# FREEZE disables physics simulation. 
	# FREEZE_MODE_KINEMATIC allows us to move it via code still.
	freeze = true 
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	
	# Optional: Disable collision so it doesn't whack the player
	$CollisionShape2D.set_deferred("disabled", true)

func drop(throw_velocity: Vector2):
	is_held = false
	freeze = false # Re-enable physics
	
	# Re-enable collision
	$CollisionShape2D.set_deferred("disabled", false)
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D(rotation, global_position)
	)
	# Give it the player's velocity so it doesn't just stop dead
	linear_velocity = throw_velocity
	
	# Optional: Add a little "throw" force away from gravity?
	# linear_velocity += -GameManager.gravity_direction * 200
