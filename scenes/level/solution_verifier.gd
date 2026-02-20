extends Node2D

var date : String = "0000"

func verify_date() -> bool:
	return (
		$NumberVerifier1.verify_number(int(date[0])) and 
		$NumberVerifier2.verify_number(int(date[1])) and
		$NumberVerifier3.verify_number(int(date[2])) and
		$NumberVerifier4.verify_number(int(date[3]))
	)
