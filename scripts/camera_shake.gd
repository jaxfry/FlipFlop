extends Node

## Trauma-based camera shake system.
##
## Usage (from anywhere):
##     CameraShake.add_trauma(0.6)     # medium shake
##     CameraShake.add_trauma(1.0)     # max shake
##
## Trauma decays over time.  The actual shake intensity is trauma² (quadratic)
## which gives a nice non-linear falloff — small bumps feel subtle while big
## hits feel powerful.

## — Tuning knobs —
## Maximum pixel offset the camera can move during a shake.
@export var max_offset := Vector2(12.0, 8.0)
## How fast trauma decays per second (higher = shorter shakes).
@export var decay_rate := 2.5
## Speed of the noise sampling.  Higher = more frantic.
@export var noise_speed := 45.0

var _trauma := 0.0
var _noise := FastNoiseLite.new()
var _noise_t := 0.0          # running time offset for noise sampling
var _camera: Camera2D = null
var _base_offset := Vector2.ZERO  # stores the camera's original offset

func _ready():
	_noise.seed = randi()
	_noise.frequency = 1.2
	_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH

func _process(delta):
	var cam = _find_camera()
	if cam == null:
		return

	# When we latch onto a new camera, remember its base offset so we add
	# our shake on top instead of overwriting it.
	if cam != _camera:
		_camera = cam
		_base_offset = cam.offset

	if _trauma <= 0.0:
		_camera.offset = _base_offset
		return

	# Decay
	_trauma = max(_trauma - decay_rate * delta, 0.0)

	# Quadratic intensity for a nicer feel
	var shake_intensity = _trauma * _trauma

	# Advance noise timeline
	_noise_t += delta * noise_speed

	# Sample two independent noise axes using different seed offsets
	# for organic, non-correlated 2D motion.
	var offset_x = _noise.get_noise_2d(_noise_t, 100.0) * max_offset.x * shake_intensity
	var offset_y = _noise.get_noise_2d(200.0, _noise_t) * max_offset.y * shake_intensity

	_camera.offset = _base_offset + Vector2(offset_x, offset_y)

## Add trauma (clamped to 1.0).  Values stack — calling add_trauma(0.3)
## twice will give 0.6 total trauma.
func add_trauma(amount: float) -> void:
	_trauma = min(_trauma + amount, 1.0)

## Convenience: one-shot shake at a fixed intensity (bypasses stacking).
func shake(intensity: float) -> void:
	_trauma = min(intensity, 1.0)

func _find_camera() -> Camera2D:
	# Primary: find via the player group (most reliable — the Camera2D is a
	# child of the instanced Player node, added per-level).
	var player = get_tree().get_first_node_in_group("player")
	if player:
		var cam = player.get_node_or_null("Camera2D")
		if cam is Camera2D:
			return cam
	# Fallback: ask the viewport for the active camera.
	var vp = get_viewport()
	if vp:
		return vp.get_camera_2d()
	return null
