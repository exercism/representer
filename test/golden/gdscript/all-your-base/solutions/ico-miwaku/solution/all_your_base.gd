func rebase(input_base: int, digits: Array, output_base: int):
	if input_base <= 1 || output_base <= 1:
		return null
	
	var num := 0
	for d in digits:
		if d < 0 || d >= input_base:
			return null
		num = num * input_base + d
		
	var result := []
	while num > 0:
		result.push_front(num % output_base)
		num /= output_base
	
	if result == []:
		result = [0]
		
	return result
