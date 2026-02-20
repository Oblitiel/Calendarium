extends GrabControllerHold
@onready var solution_verifier = $SolutionVerifier

func _ready():
	var date = Time.get_datetime_dict_from_system()
	solution_verifier.date = "%02d%02d" % [date.day,date.month]
