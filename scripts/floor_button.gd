extends Area2D

# Assign the door in the editor — the wire draws itself.
@export var linked_door : StaticBody2D
## Optional: extra waypoints between button and door (in local level coords).
## Leave empty for a direct straight line.
@export var wire_waypoints : PackedVector2Array = PackedVector2Array()

@onready var sprite = $AnimatedSprite2D

var wire_off_color := Color("4d1118")
var wire_on_color  := Color("9e2230")
var _wire : Line2D

var bodies_on_button = 0
var is_pressed = false

func _ready():
	if linked_door != null:
		linked_door.register_button()
		_create_wire()

func _create_wire():
	_wire = Line2D.new()
	_wire.width = 1.0
	_wire.default_color = wire_off_color
	# Build points: button → waypoints → door (all in parent/level coords)
	var points := PackedVector2Array()
	points.append(global_position)
	for wp in wire_waypoints:
		points.append(wp)
	points.append(linked_door.global_position)
	# Trim start/end so wire stops at each object's edge
	var btn_trim = _get_edge_distance(self, points[1] - points[0])
	var last = points.size() - 1
	var door_trim = _get_edge_distance(linked_door, points[last - 1] - points[last])
	points[0] += (points[1] - points[0]).normalized() * btn_trim
	points[last] += (points[last - 1] - points[last]).normalized() * door_trim
	_wire.points = points
	# Add to the level root so coords are in world space
	get_parent().add_child.call_deferred(_wire)

## Compute how far along a direction we must go to exit a node's collision box.
## Accounts for the node's rotation and scale so rotated / scaled doors trim correctly.
func _get_edge_distance(node: Node2D, direction: Vector2) -> float:
	var cs = node.get_node_or_null("CollisionShape2D")
	if cs == null or not (cs.shape is RectangleShape2D):
		return 16.0
	# Half-extents in the node's local space (collision-shape scale only)
	var half = cs.shape.size * Vector2(abs(cs.scale.x), abs(cs.scale.y)) / 2.0
	# Rotate the world-space direction into the node's local space
	var dir_local = direction.rotated(-node.global_rotation).normalized()
	var t = INF
	if abs(dir_local.x) > 0.001:
		t = min(t, half.x / abs(dir_local.x))
	if abs(dir_local.y) > 0.001:
		t = min(t, half.y / abs(dir_local.y))
	# Convert the local-space edge point back to world-space distance
	var local_edge = dir_local * t
	var world_dist = (local_edge * node.global_scale).length()
	return world_dist + 2.0

func _on_body_entered(body):
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_button += 1
		_check_state()

func _on_body_exited(body):
	if body is CharacterBody2D or body is RigidBody2D:
		bodies_on_button -= 1
		_check_state()

func _check_state():
	if linked_door == null:
		return

	if bodies_on_button > 0 and not is_pressed:
		is_pressed = true
		$AnimatedSprite2D.frame = 1
		linked_door.button_pressed()
		if _wire:
			_wire.default_color = wire_on_color
	elif bodies_on_button <= 0 and is_pressed:
		is_pressed = false
		$AnimatedSprite2D.frame = 0
		linked_door.button_released()
		if _wire:
			_wire.default_color = wire_off_color
		
