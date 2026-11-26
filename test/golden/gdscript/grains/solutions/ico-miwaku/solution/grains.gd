func square(num: int) -> Variant:
	if num <= 0 or num >= 64: return null
	return 2 ** (num - 1)


func total() -> int:
	var total := 0
	for i in 63:
		total += square(i + 1)
	return total
