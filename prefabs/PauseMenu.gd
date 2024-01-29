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
	$OuterMenu1/InnerMenu1/NameText.text = Stats.STATS_DICTIONARY["Name"]
	$OuterMenu1/InnerMenu1/StatText.text = "LV   %d\nHP   %d/%d\nG     %d" % [Stats.STATS_DICTIONARY["Love"], Stats.STATS_DICTIONARY["Current_HP"], Stats.STATS_DICTIONARY["Max_HP"], Stats.STATS_DICTIONARY["Gold"]]

func _on_underground_camera_game_paused():
	get_tree().paused = true
