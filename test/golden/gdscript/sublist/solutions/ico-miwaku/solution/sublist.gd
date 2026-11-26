func sublist(list_one: Array, list_two: Array) -> String:
	if list_one == list_two:
		return "equal"
	
	var swapped := false
	if list_one.size() < list_two.size():
		var tmp := list_one
		list_one = list_two
		list_two = tmp
		swapped = true
	
	for i in list_one.size() - list_two.size() + 1:
		if list_one.slice(i, i + list_two.size()) == list_two:
			return "sublist" if swapped else "superlist"
		
	return "unequal"
