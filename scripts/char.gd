extends AnimatedSprite2D

var velocity = Vector2(200, 150)
var rotation_speed = 2.0
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	position += velocity * delta
	rotation += rotation_speed * delta
	
	if position.x >= screen_size.x or position.x <= 0:
		velocity.x *= -1
		
	if position.y >= screen_size.y or position.y <= 0:
		velocity.y *= -1
