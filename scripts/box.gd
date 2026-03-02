extends RigidBody2D

@export var gravity_multiplier: float = 1.1

var is_held = false

func _physics_process(delta):
	if is_held:
		return

	var force = GameManager.gravity_direction * GameManager.gravity_power * mass * gravity_multiplier
	apply_central_force(force)

func pick_up():
	is_held = true
	freeze = true
	freeze_mode = RigidBody2D.FREEZE_MODE_KINEMATIC
	$CollisionShape2D.set_deferred("disabled", true)

func drop(throw_velocity: Vector2):
	is_held = false
	freeze = false
	$CollisionShape2D.set_deferred("disabled", false)
	PhysicsServer2D.body_set_state(
		get_rid(),
		PhysicsServer2D.BODY_STATE_TRANSFORM,
		Transform2D(rotation, global_position)
	)
	linear_velocity = throw_velocity
