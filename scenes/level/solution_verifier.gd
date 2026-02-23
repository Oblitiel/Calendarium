extends Node2D

var date_string : String = "0000"

func _ready() -> void:
	date_string = Game.get_date_string()
	Game.solution_verifier = self

func verify_date() -> bool:
	for i in 4:
		if not get_children()[i].verify_number(int(date_string[i])):
			return false
	
	return true
