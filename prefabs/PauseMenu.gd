extends VBoxContainer

signal game_unpaused

func _ready():
	hide()
	rebuild()

func _process(_delta):
	show()

func _input(event):
	if event.is_action_pressed("menu"):
		hide()
		emit_signal("game_unpaused")

func rebuild():
	$OuterMenu1/InnerMenu1/NameText.text = Stats.STAT_DICTIONARY["Name"]
	$OuterMenu1/InnerMenu1/StatText.text = "LV   %d\nHP   %d/%d\nG     %d" % [Stats.STAT_DICTIONARY["Love"], Stats.STAT_DICTIONARY["Current_HP"], Stats.STAT_DICTIONARY["Max_HP"], Stats.STAT_DICTIONARY["Gold"]]

func _on_underground_camera_game_paused():
	get_tree().paused = true
