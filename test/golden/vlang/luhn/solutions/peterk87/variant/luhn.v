module main

fn valid(value string) bool {
	revstr := value.replace(' ', '').reverse()
	if revstr.len < 2 {
		return false
	}
	mut sum_nums:= u64(0)
	for i, c in revstr {
		int_val := c - `0`
		if int_val > 9 || int_val < 0 {
			return false
		}
		mut n := u64(0)
		if i % 2 != 0 {
			n = u64(int_val)
		} else {
			n = u64(int_val) * 2
			if n > 9 {
				n -= 9
			}
		}
		sum_nums += n
	}
	return sum_nums % 10 == 0
}
