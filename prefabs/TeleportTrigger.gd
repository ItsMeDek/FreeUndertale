extends Area2D

signal teleport

## The node that triggers the teleporter on contact.
@export var TELEPORT_NODE: Node2D
## The ID of the scene that our game will switch to once teleport node enters the trigger.
@export var TELEPORT_SCENE_ID: int

func _on_body_entered(body: Node2D):
	if body == TELEPORT_NODE:
		emit_signal("teleport")

func _on_teleport_timer_timeout():
	SaveManager.change_room(TELEPORT_SCENE_ID)

func _on_teleport():
	$TeleportTimer.start()
	TELEPORT_NODE.process_mode = Node.PROCESS_MODE_DISABLED
