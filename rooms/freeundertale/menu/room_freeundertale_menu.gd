extends Control

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://rooms/ruins/room_area1.tscn")

func _on_load_button_pressed():
	$Buttons/FileDialog.show()

func _on_exit_button_pressed():
	get_tree().quit()

func _on_file_dialog_file_selected(path: String):
	SaveManager.load(path)
