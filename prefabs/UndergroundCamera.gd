extends Camera2D

@export var NODE_TO_FOLLOW: Node2D

@export var LOWER_POSITION_LIMIT: Vector2 = Vector2(0.0, 0.0)
@export var HIGHER_POSITION_LIMIT: Vector2 = Vector2(500, 500)

func _process(_delta: float):
	position.x = clamp(NODE_TO_FOLLOW.position.x, LOWER_POSITION_LIMIT.x, HIGHER_POSITION_LIMIT.x)
	position.y = clamp(NODE_TO_FOLLOW.position.y, LOWER_POSITION_LIMIT.y, HIGHER_POSITION_LIMIT.y)
