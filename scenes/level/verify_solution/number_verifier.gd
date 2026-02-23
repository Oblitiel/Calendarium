extends Area2D

func verify_number(number : int) -> bool:
	var areas = get_overlapping_areas()
	var subpieces : Array[Subpiece]
	subpieces.assign(areas.filter(
		func(p):
			return p is Subpiece
	))
	
	if subpieces.size() < 4:
		return false
	
	for subpiece in subpieces:
		if not subpiece.data.accepted_numbers.has(number):
			return false
	return true
