package pythagorean

type Triplet [3]int

// Range generates list of all Pythagorean triplets with side lengths
// in the provided range.
func Range(min, max int) []Triplet {
	result := make([]Triplet, 0)

	for a := min; a <= (max - 2); a += 1 {
		for b := (a + 1); b <= (max - 1); b += 1 {
			for c := (b + 1); c <= max; c += 1 {
				if (a*a)+(b*b) == (c * c) {
					result = append(result, Triplet{a, b, c})
				}
			}
		}
	}

	return result
}

// Sum returns a list of all Pythagorean triplets with a certain perimeter.
func Sum(p int) []Triplet {
	result := make([]Triplet, 0)

	aLimit := p / 3
	bLimit := p / 2

	for a := 1; a < aLimit; a += 1 {
		for b := (a + 1); b < bLimit; b += 1 {
			c := p - a - b
			if (c > b) && ((a*a)+(b*b) == (c * c)) {
				result = append(result, Triplet{a, b, c})
			}
		}
	}

	return result
}
