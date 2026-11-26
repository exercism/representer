package pythagorean_triplet

Triplet :: struct {
	a, b, c: int,
}

triplets_with_sum :: proc(sum: int) -> []Triplet {
	triplets := make([dynamic]Triplet)
    for a in 1..<sum/3 {
        for b in (a+1)..=(sum-a)/2 {
            c := sum - a - b
            if a*a + b*b == c*c {
                append(&triplets, Triplet{a, b, c})
            }
        }
    }
    shrink(&triplets)
	return triplets[:]
}
