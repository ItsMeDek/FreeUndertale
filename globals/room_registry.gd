extends Node

class Room:
	func _init(room_name: String, room_type: String):
		self.name = room_name
		self.type = room_type
	
	var name: String
	var type: String

var ROOM_DICTIONARY: Dictionary = {
	4: Room.new("room_area1", "ruins")
}
