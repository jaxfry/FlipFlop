extends CharacterBody2D

@export var move_speed: float = 130.0
@export var jump_force: float = 300.0
@export var push_strength: float = 100.0

@onready var carry_pos = $CarryPos
@onready var pickup_area = $PickupArea
@onready var sprite = $AnimatedSprite2D
@onready var camera = $Camera2D

var held_object: RigidBody2D = null
var _was_on_floor := true
var _fall_speed := 0.0

## Minimum fall speed (px/s along gravity axis) required to trigger a landing shake.
const LAND_SHAKE_MIN_SPEED := 200.0
## Fall speed that produces maximum landing shake.
const LAND_SHAKE_MAX_SPEED := 500.0

func _ready():
	add_to_group("player")
	GameManager.gravity_direction = Vector2(0, 1)
	GameManager.gravity_power = 980.0
	rotation = 0
	# Snap camera to player position on spawn/respawn to avoid the
	# smooth-from-origin sweep that happens after a scene reload.
	camera.reset_smoothing()

func _physics_process(delta):
	var grav_dir = GameManager.gravity_direction

	if is_on_floor():
		if Input.is_action_just_pressed("grav_up"):
			GameManager.change_gravity(Vector2(0, -1))
		elif Input.is_action_just_pressed("grav_down"):
			GameManager.change_gravity(Vector2(0, 1))
		elif Input.is_action_just_pressed("grav_left"):
			GameManager.change_gravity(Vector2(-1, 0))
		elif Input.is_action_just_pressed("grav_right"):
			GameManager.change_gravity(Vector2(1, 0))

	up_direction = -grav_dir
	if not is_on_floor():
		velocity += grav_dir * GameManager.gravity_power * delta
	rotation = lerp_angle(rotation, up_direction.angle() + PI / 2, 20.0 * delta)

	var input = Input.get_axis("move_left", "move_right")

	if input != 0:
		var is_inverted = grav_dir.y < 0 or grav_dir.x > 0
		sprite.flip_h = (input > 0) if is_inverted else (input < 0)

	if grav_dir.x == 0:
		if input:
			velocity.x = input * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0.0, move_speed)
	else:
		if input:
			velocity.y = input * move_speed
		else:
			velocity.y = move_toward(velocity.y, 0.0, move_speed)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity += -grav_dir * jump_force

	if held_object:
		held_object.global_position = carry_pos.global_position
		held_object.rotation = rotation

	if is_on_floor():
		sprite.play("walk" if input != 0 else "default")
	else:
		sprite.play("default")

	# --- Landing detection (before move_and_slide changes is_on_floor) ---
	var on_floor_now = is_on_floor()

	# Track how fast we're falling along the gravity axis
	var grav_speed = velocity.dot(grav_dir)
	if not on_floor_now:
		_fall_speed = max(_fall_speed, grav_speed)

	move_and_slide()

	# Detect the frame we land
	if is_on_floor() and not _was_on_floor:
		if _fall_speed >= LAND_SHAKE_MIN_SPEED:
			var t = clamp((_fall_speed - LAND_SHAKE_MIN_SPEED) / (LAND_SHAKE_MAX_SPEED - LAND_SHAKE_MIN_SPEED), 0.0, 1.0)
			CameraShake.add_trauma(lerp(0.2, 0.5, t))
		_fall_speed = 0.0
	_was_on_floor = is_on_floor()

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is RigidBody2D and collider != held_object:
			var push_dir = -collision.get_normal()
			# Don't push the box in the gravity direction (prevents phasing through floor)
			if push_dir.dot(GameManager.gravity_direction) > 0.5:
				continue
			collider.apply_central_impulse(push_dir * push_strength)

func _input(event):
	if event.is_action_pressed("interact"):
		if held_object:
			drop_object()
		else:
			attempt_pickup()

func attempt_pickup():
	for body in pickup_area.get_overlapping_bodies():
		if body.has_method("pick_up"):
			held_object = body
			held_object.pick_up()
			break

func drop_object():
	if not held_object:
		return

	var box_ref = held_object
	held_object = null

	# When gravity is inverted (up) or rightward, sprite.flip_h has the opposite
	# meaning for the throw direction, so we negate facing to compensate.
	var is_inverted = GameManager.gravity_direction.y < 0 or GameManager.gravity_direction.x > 0
	var facing = -1.0 if sprite.flip_h else 1.0
	if is_inverted:
		facing = -facing
	var throw_dir = Vector2.ZERO
	if GameManager.gravity_direction.x == 0:
		throw_dir.x = facing
	else:
		throw_dir.y = facing

	box_ref.global_position = carry_pos.global_position
	box_ref.add_collision_exception_with(self)
	box_ref.drop(velocity + throw_dir * 200.0)

	await get_tree().create_timer(0.5).timeout
	if is_instance_valid(box_ref):
		box_ref.remove_collision_exception_with(self)
