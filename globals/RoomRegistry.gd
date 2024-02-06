extends Node

@export var ENABLE_DOGCHECK: bool = true

class Room:
	func _init(room_name: String, room_type: String, dogcheck_status: bool):
		self.name = room_name
		self.type = room_type
		self.dogchecked = dogcheck_status
	
	var name: String
	var type: String
	var dogchecked: bool

var ROOM_DICTIONARY: Dictionary = {
	4: Room.new("room_area1", "ruins", false),
	326: Room.new("room_of_dog", "unused", false)
}
