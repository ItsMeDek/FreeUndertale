extends Node

@export var PREFERRED_LAYOUT = "undertale_layout"

func _ready():
	print("Saving a test file!")
	save("test")

func query_preferred_layout() -> FileAccess:
	var layout_directory: DirAccess = DirAccess.open("res://layouts")
	var layout_filenames: PackedStringArray = layout_directory.get_files()
	var file: FileAccess
	
	for filename in layout_filenames:
		if filename == PREFERRED_LAYOUT + ".txt":
			file = FileAccess.open("res://layouts/" + filename, FileAccess.READ)
		
	return file

func save(filename: String):
	var save_file: FileAccess = FileAccess.open("user://" + filename, FileAccess.WRITE)
	save_data(save_file)

func load(filename: String):
	var save_file: FileAccess = FileAccess.open(filename, FileAccess.READ)
	load_data(save_file)

func save_data(save_file: FileAccess):
	var layout: FileAccess = query_preferred_layout()
	var layout_array: PackedStringArray = layout.get_as_text().split('\n')

	var buffer: String = ""
	for line in layout_array:
		if line == "":
			continue
		elif line.find("[") != -1:
			var line_elements: PackedStringArray = line.replace("]", "").split("[")
			
			if line_elements[0].find("Flag") != -1:
				# TODO
				buffer += "69" + " "
			else:
				var array: Array = Stats.STAT_DICTIONARY[line_elements[0]]
				buffer += str(array[int(line_elements[1])]) + " "
		elif line.find("/") != -1:
			buffer += Stats.STAT_DICTIONARY[line.replace("/", "")]
		else:
			buffer += str(Stats.STAT_DICTIONARY[line]) + " "
		buffer += "\r\n"
	
	save_file.store_string(buffer)
	
	layout.close()
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
		if stat == "Menu_Choice":
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
	
	var dogcheck_enabled: bool = RoomRegistry.ENABLE_DOGCHECK
	var room_dogchecked: bool = RoomRegistry.ROOM_DICTIONARY[Stats.STAT_DICTIONARY["RoomID"]].dogchecked
	
	if dogcheck_enabled and room_dogchecked:
		change_room(326)
	else:
		change_room(Stats.STAT_DICTIONARY["RoomID"])
	save_file.close()

func change_room(room_ID: int):
	Stats.STAT_DICTIONARY["RoomID"] = room_ID
	
	var room = RoomRegistry.ROOM_DICTIONARY[room_ID]
	
	var room_name: String = room.name
	var room_type: String = room.type
	
	var room_path: String = "res://rooms/%s/%s.tscn" % [room_type, room_name]	
	get_tree().change_scene_to_file(room_path)
