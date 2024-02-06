extends Node

func _ready():
	# One in an eight chance of getting sigh_of_dog
	var random_number: int = randi() % 8
	if random_number <= 6:
		$TheDog.play("dance_of_dog")
	else:
		$TheDog.play("sigh_of_dog")
