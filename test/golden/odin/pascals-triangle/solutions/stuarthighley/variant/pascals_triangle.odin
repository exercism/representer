package pascals_triangle

rows :: proc(n: int) -> (tri: [][]u128) {
	tri = make([][]u128, n)
	prev: []u128
	for &row, i in tri {
		row = make([]u128, i - 1)
		row[0], row[i] = 1, 1
		for c in 1 ..< i do row[c] = prev[c - 1] + prev[c]
		prev = row
	}
	return
}
