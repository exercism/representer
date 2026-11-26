func prime(n):
	if n < 0:
		return null
	
	var v := 2
	while true:
		if is_prime(v):
			if n == 1:
				return v
			else:
				n -= 1
		v += 1
	return prime


func is_prime(n: int) -> bool:
	if n == 2: return true
	if n % 2 == 0: return false
	for i in range(3, sqrt(n) + 1, 2):
		if n % i == 0:
			return false
	return true
