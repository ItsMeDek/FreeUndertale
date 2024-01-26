extends StaticBody2D

@export var MOVEMENT_SPEED: float = 180.0

func _ready():
	$AnimatedSprite2D.animation = "move_south"

func _process(delta):
	var moving: bool = false
	var animation_playing: bool = false
	
	if Input.is_action_pressed("move_west"):
		if !animation_playing:
			$AnimatedSprite2D.play("move_west")
		self.position.x += -1.0 * delta * MOVEMENT_SPEED
		
		moving = true
		animation_playing = true
	if Input.is_action_pressed("move_east"):
		if !animation_playing:
			$AnimatedSprite2D.play("move_east")
		self.position.x += 1.0 * delta * MOVEMENT_SPEED
		
		moving = true
		animation_playing = true
	if Input.is_action_pressed("move_north"):
		if !animation_playing:
			$AnimatedSprite2D.play("move_north")
		self.position.y += -1.0 * delta * MOVEMENT_SPEED
		
		moving = true
		animation_playing = true
	if Input.is_action_pressed("move_south"):
		if !animation_playing:
			$AnimatedSprite2D.play("move_south")
		self.position.y += 1.0 * delta * MOVEMENT_SPEED
		
		moving = true
		animation_playing = true
	
	if !moving:
		$AnimatedSprite2D.stop()
