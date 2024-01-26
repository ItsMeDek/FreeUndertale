extends Node

func _ready():
	print("Saving a test file!")
	save("test")

func save(filename: String):
	var save_file: FileAccess = FileAccess.open("user://" + filename, FileAccess.WRITE)
	save_data(save_file)

func save_data(save_file: FileAccess):
	# First we save the player name WITHOUT a space following it (Because Undertale does that for some reason)
	# Then, we construct a dictionary identical to the main stats dictionary, but without the Name member
	save_file.store_string(Stats.STATS_DICTIONARY["Name"] + '\n')
	var stats2 = Stats.STATS_DICTIONARY.duplicate()
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
				buffer += str(member) + ' \n'
		# We save every other member in a separate line
		else:
			buffer += str(stat) + ' \n'
		# In Undertale, flags are saved on lines 31-543
		# Currently, the flags are stubs. In the future, we'll implement those flags one by one.
		if iteration == 30:
			print("TODO: Implement proper flag saving!")
			for i in range(0, 512):
				buffer += str(i) + '\n'
	# Finally, we delete the last line break, copy the buffer into the save file and close the save file
	buffer = buffer.erase(buffer.length() - 1)
	save_file.store_string(buffer)
	save_file.close()
