package collatz_conjecture

steps :: proc(start: int) -> (result: int, ok: bool) {
	count: int
	current_num: int = start
	for current_num >= 1 {
		count += 1
		if current_num % 2 == 0 do current_num /= 2
		else do current_num = current_num * 3 + 1
	}
	return count, true if current_num == 1 else false
}
