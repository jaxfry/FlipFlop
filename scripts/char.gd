extends AnimatedSprite2D

var velocity = Vector2(200, 150) # The speed and direction
var rotation_speed = 2.0         # How fast it spins
var screen_size

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	# Move the sprite
	position += velocity * delta
	# Rotate the sprite
	rotation += rotation_speed * delta
	
	# Bounce off the Left and Right walls
	if position.x >= screen_size.x or position.x <= 0:
		velocity.x *= -1
		
	# Bounce off the Top and Bottom walls
	if position.y >= screen_size.y or position.y <= 0:
		velocity.y *= -1
