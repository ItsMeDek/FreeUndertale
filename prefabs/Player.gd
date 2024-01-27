extends CharacterBody2D

@export var MOVEMENT_SPEED: float = 200.0

func _ready():
	$AnimatedSprite2D.animation = "move_south"

func _physics_process(_delta: float):
	var moving: bool = false
	
	var movement_direction: Vector2 = Input.get_vector("move_west", "move_east", "move_north", "move_south")
	if movement_direction.x > 0.0 and !moving:
		$AnimatedSprite2D.play("move_east")
		moving = true
	if movement_direction.x < 0.0 and !moving:
		$AnimatedSprite2D.play("move_west")
		moving = true
	if movement_direction.y > 0.0 and !moving:
		$AnimatedSprite2D.play("move_south")
		moving = true
	if movement_direction.y < 0.0 and !moving:
		$AnimatedSprite2D.play("move_north")
		moving = true

	if !moving:
		$AnimatedSprite2D.stop()
	
	velocity = movement_direction * MOVEMENT_SPEED
	move_and_slide()
