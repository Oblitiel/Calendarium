extends Node

enum DATE_FORMATS {
	DD_MM,
	MM_DD
}

var date_format : DATE_FORMATS = DATE_FORMATS.DD_MM
var solution_verifier

signal win()

func get_date_string() -> String:
	var date_dic = Time.get_datetime_dict_from_system()
	
	match date_format:
		DATE_FORMATS.DD_MM:
			return "%02d%02d" % [date_dic.day, date_dic.month]
		DATE_FORMATS.MM_DD:
			return "%02d%02d" % [date_dic.month, date_dic.day]
		_:
			push_error("No date format value")
	
	return ""

func check_win() -> void:
	if solution_verifier.verify_date():
		play_win_anim()

func play_win_anim():
	win.emit()
