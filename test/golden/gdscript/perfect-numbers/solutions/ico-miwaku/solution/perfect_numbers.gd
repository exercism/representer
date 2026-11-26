func classify(number: int) -> Variant:
	if number <= 0:
		return null
	
	var sum := 0
	for n in range(1, number):
		if number % n == 0:
			sum += n
			
	if sum == number:
		return "perfect"
	elif sum > number:
		return "abundant"
	else:
		return "deficient"
