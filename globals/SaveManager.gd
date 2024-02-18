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

func load_data(save_file: FileAccess):
	var layout: FileAccess = query_preferred_layout()
	var layout_array: PackedStringArray = layout.get_as_text().replace("/", "").split('\n')
	
	var save_file_array: PackedStringArray = save_file.get_as_text().split('\r\n')
	
	var iteration: int = 0
	for line in layout_array:
		if line == "":
			pass
		elif line.find("[") != -1:
			var line_elements: PackedStringArray = line.replace("]", "").split("[")
			
			if line_elements[0].find("Flag") != -1:
				# TODO
				pass
			else:
				var array: Array = Stats.STAT_DICTIONARY[line_elements[0]]
				array[int(line_elements[1])] = save_file_array[iteration]
		else:
			var numeric_value = str_to_var(save_file_array[iteration])
			if numeric_value != null:
				Stats.STAT_DICTIONARY[line] = numeric_value
			else:
				Stats.STAT_DICTIONARY[line] = save_file_array[iteration]

		iteration += 1
	
	var roomid: int = int(Stats.STAT_DICTIONARY["RoomID"])
	
	var dogcheck_enabled: bool = RoomRegistry.ENABLE_DOGCHECK
	var room_dogchecked: bool = RoomRegistry.ROOM_DICTIONARY[roomid].dogchecked
	
	if dogcheck_enabled and room_dogchecked:
		change_room(326)
	else:
		change_room(roomid)
	
	layout.close()
	save_file.close()

func change_room(room_ID: int):
	Stats.STAT_DICTIONARY["RoomID"] = room_ID
	
	var room = RoomRegistry.ROOM_DICTIONARY[room_ID]
	
	var room_name: String = room.name
	var room_type: String = room.type
	
	var room_path: String = "res://rooms/%s/%s.tscn" % [room_type, room_name]	
	get_tree().change_scene_to_file(room_path)
