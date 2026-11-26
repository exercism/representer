package binarysearch

// SearchInts performs binary search returning index of the match.
// -1 if the key is not found or array is 0 length.
func SearchInts(s []int, key int) int {
	l := 0
	r := len(s) - 1
	for l <= r {
		c := (l + r) / 2
		if s[c] == key{
			return c
		} else if s[c] < key{
			l = c + 1
		} else {
			r = c - 1
		}
	}
	return -1	
}
