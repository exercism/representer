func egg_count(display_value: int) -> int:
	var count := 0
	while display_value > 0:
		if display_value & 1: count += 1
		display_value >>= 1
	return count
