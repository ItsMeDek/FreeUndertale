extends StaticBody2D

@export var MOVEMENT_SPEED: float = 200.0

func _ready():
	$AnimatedSprite2D.animation = "move_south"

func _process(delta):
	var moving: bool = false
	
	if Input.is_action_pressed("move_north"):
		self.position.y += -1.0 * delta * MOVEMENT_SPEED
		$AnimatedSprite2D.play("move_north")
		moving = true
	elif Input.is_action_pressed("move_south"):
		self.position.y += 1.0 * delta * MOVEMENT_SPEED
		$AnimatedSprite2D.play("move_south")
		moving = true
	elif Input.is_action_pressed("move_west"):
		self.position.x += -1.0 * delta * MOVEMENT_SPEED
		$AnimatedSprite2D.play("move_west")
		moving = true
	elif Input.is_action_pressed("move_east"):
		self.position.x += 1.0 * delta * MOVEMENT_SPEED
		$AnimatedSprite2D.play("move_east")
		moving = true
	
	if !moving:
		$AnimatedSprite2D.stop()
