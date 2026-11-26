package pythagorean

type Triplet [3]int

func isTriplet(triple Triplet) bool {
	if triple[0] <= 0 || triple[1] <= 0 || triple[2] <= 0 {
		return false
	}
	return triple[0]*triple[0]+triple[1]*triple[1] == triple[2]*triple[2]
}

func Range(min int, max int) []Triplet {
	var results []Triplet
	for i := min; i <= max; i++ {
		for j := i; j <= max; j++ {
			for k := j; k <= max; k++ {
				triple := Triplet{i, j, k}
				if isTriplet(triple) {
					results = append(results, triple)
				}
			}
		}
	}
	return results
}

func Sum(p int) []Triplet {
	var results []Triplet
	for i := 1; i <= p/3; i++ {
		for j := i; j <= p/2; j++ {
			triple := Triplet{i, j, p - i - j}
			if isTriplet(triple) {
				results = append(results, triple)
			}
		}
	}
	return results
}