func find(search_list: Array, value: int) -> Variant:
	var lower := 0
	var upper := search_list.size() - 1
	
	while lower <= upper:
		var middle := lower + (upper - lower) / 2
		var item: int = search_list[middle]
		
		if item == value: return middle
		
		if item > value:
			upper = middle - 1
		elif item < value:
			lower = middle + 1
			
	return null
