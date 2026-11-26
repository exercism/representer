func steps(number: int) -> Variant:
	if number <= 0:
		return ERR_INVALID_PARAMETER
	
	var steps := 0
	
	while number != 1:
		if number % 2 == 0:
			number /= 2
		else:
			number = 3 / number + 1
		steps += 1

	return steps
