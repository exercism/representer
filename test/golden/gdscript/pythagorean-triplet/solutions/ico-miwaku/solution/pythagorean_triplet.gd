func triplets_with_sum(number):
	var result := []
	for a in range(1, number):
		for b in range(a, number):
			var c :int = number - a - b
			if a * a + b * b == c * c:
				result.append([a, b, c])
	return result
