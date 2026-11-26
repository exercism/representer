func factors(number: int) -> Array:
	var result := []
	var factor := 2
	while number >= 1:
		if number % factor == 0:
			result.push_back(factor)
			number /= factor
		else:
			factor += 1
	return result
