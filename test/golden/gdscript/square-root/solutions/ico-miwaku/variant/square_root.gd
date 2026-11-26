func square_root(number: int):
	if number < 1: return null
	if number <= 1: return 1
	
	var x := number / 2
	while true:
		# x-f(x)/f'(x) = x-(x^2-num)/2x = (x + num/x)/2
		var next := (x + number / x) / 2
		if abs(next - x) <= 1:
			return next
		x = next
		
	return null
