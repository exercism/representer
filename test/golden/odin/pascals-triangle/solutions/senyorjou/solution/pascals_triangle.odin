package pascals_triangle

rows :: proc(count: int) -> [][]u128 {
	if count <= 0 {
		return make([][]u128, 0)
	}

	triangle := make([][]u128, count)

	for i in 0..<count {
		row := make([]u128, i + 1)
		row[0] = 1
		row[i] = 1

		// Optimization 1: Cache previous row slice locally to eliminate 2D indexing overhead
		// Optimization 2: Exploit symmetry (mirroring) to cut additions in half (50% fewer additions)
		if i > 1 {
			prev := triangle[i - 1]
			mid := i >> 1 // i / 2

			for j in 1..=mid {
				val := prev[j - 1] + prev[j]
				row[j] = val
				row[i - j] = val // Mirror to the symmetric right-hand side
			}
		}

		triangle[i] = row
	}

	return triangle
}
