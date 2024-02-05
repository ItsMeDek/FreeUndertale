extends Node

func _ready():
	print("Saving a test file!")
	save("test")

func save(filename: String):
	var save_file: FileAccess = FileAccess.open("user://" + filename, FileAccess.WRITE)
	save_data(save_file)

func load(filename: String):
	var save_file: FileAccess = FileAccess.open(filename, FileAccess.READ)
	load_data(save_file)

func save_data(save_file: FileAccess):
	# First we save the player name WITHOUT a space following it (Because Undertale does that for some reason)
	# Then, we construct a dictionary identical to the main stats dictionary, but without the Name member
	save_file.store_string(Stats.STAT_DICTIONARY["Name"] + '\r\n')
	var stats2 = Stats.STAT_DICTIONARY.duplicate()
	stats2.erase("Name")
	# Afterwards we create a buffer which stores the data to be saved
	var buffer: String = ""
	# Next, we start iterating over every value in the newly constructed stats2 dictionary
	var iteration: int = 0
	for stat in stats2.values():
		iteration += 1
		# We save arrays by storing every member in a separate line
		if typeof(stat) == TYPE_ARRAY:
			for member in stat:
				iteration += 1
				buffer += str(member) + ' \r\n'
		# We save every other member in a separate line
		else:
			buffer += str(stat) + ' \r\n'
		# In Undertale, flags are saved on lines 31-543
		# Currently, the flags are stubs. In the future, we'll implement those flags one by one.
		if iteration == 30:
			print("TODO: Implement proper flag saving!")
			for i in range(0, 512):
				buffer += str(i) + '\r\n'
	# Finally, we delete the last line break, copy the buffer into the save file and close the save file
	buffer = buffer.erase(buffer.length() - 1)
	save_file.store_string(buffer)
	save_file.close()

# HEADS UP: This code is so broken, hacky and unmaintainable that it requires a full rewrite.
# If you find a bug related to loading, don't modify this function unless you want your life to turn into hell.
func load_data(save_file: FileAccess):
	var file_contents: PackedStringArray = save_file.get_as_text().split('\r\n')
	
	var phoneitem_array: Array[int] = [0]
	phoneitem_array.resize(16)
	for i in range(12, 28):
		phoneitem_array[i - 12] = file_contents[i].replace(' ', '').to_int()
	
	for i in range(0, 8):	
		Stats.STAT_DICTIONARY["PhoneItem_Array1"][i] = phoneitem_array[i]
	
	for i in range(8, 16):
		Stats.STAT_DICTIONARY["PhoneItem_Array2"][i - 8] = phoneitem_array[i]
	
	# TODO: Implement flag loading
	var flags: Array[int]
	flags.resize(512)
	for i in range(29, 541):
		flags[i - 29] = file_contents[i].replace(' ', '').to_int()
	
	var iteration: int = 0
	for stat in Stats.STAT_DICTIONARY.keys():
		if stat.find("PhoneItem_Array") != -1:
			iteration += 8
			continue
		if stat == "Plot":
			iteration += 512
		if stat == "Menu_choice":
			Stats.STAT_DICTIONARY[stat] = [file_contents[iteration].replace(' ', '').to_int(), file_contents[iteration + 1].replace(' ', '').to_int(), file_contents[iteration + 2].replace(' ', '').to_int()]
			iteration += 3
		elif typeof(Stats.STAT_DICTIONARY[stat]) == TYPE_STRING:
			Stats.STAT_DICTIONARY[stat] = file_contents[iteration].replace(' ', '')
			iteration += 1
		elif typeof(Stats.STAT_DICTIONARY[stat]) == TYPE_FLOAT:
			Stats.STAT_DICTIONARY[stat] = file_contents[iteration].replace(' ', '').to_float()
			iteration += 1
		else:
			Stats.STAT_DICTIONARY[stat] = file_contents[iteration].replace(' ', '').to_int()
			iteration += 1
	
	change_room(RoomRegistry.ROOM_DICTIONARY[Stats.STAT_DICTIONARY["RoomID"]])
	save_file.close()

func change_room(room: RoomRegistry.Room):
	var room_name: String = room.name
	var room_type: String = room.type
	var room_path: String = "res://rooms/%s/%s.tscn" % [room_type, room_name]
	get_tree().change_scene_to_file(room_path)
