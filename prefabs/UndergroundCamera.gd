extends Camera2D

signal game_paused

@export var NODE_TO_FOLLOW: Node2D
@export var LOWER_POSITION_LIMIT: Vector2 = Vector2(0.0, 0.0)
@export var HIGHER_POSITION_LIMIT: Vector2 = Vector2(500, 500)

var can_pause: bool = true

func fadein():
	$AnimationPlayer.play("camera_fadein")

func fadeout():
	$AnimationPlayer.play("camera_fadeout")

func _ready():
	$Fadeout.show()
	fadein()

func _process(_delta: float):
	position.x = clamp(NODE_TO_FOLLOW.position.x, LOWER_POSITION_LIMIT.x, HIGHER_POSITION_LIMIT.x)
	position.y = clamp(NODE_TO_FOLLOW.position.y, LOWER_POSITION_LIMIT.y, HIGHER_POSITION_LIMIT.y)

func _input(event):
	if event.is_action_pressed("menu") and can_pause:
		emit_signal("game_paused")
	can_pause = true

func _on_pause_menu_game_unpaused():
	get_tree().paused = false
	can_pause = false

func _on_teleport_trigger_teleport():
	fadeout()
